//LIC// ====================================================================
//LIC// This file forms part of oomph-lib, the object-oriented, 
//LIC// multi-physics finite-element library, available 
//LIC// at http://www.oomph-lib.org.
//LIC// 
//LIC//           Version 0.90. August 3, 2009.
//LIC// 
//LIC// Copyright (C) 2006-2009 Matthias Heil and Andrew Hazel
//LIC// 
//LIC// This library is free software; you can redistribute it and/or
//LIC// modify it under the terms of the GNU Lesser General Public
//LIC// License as published by the Free Software Foundation; either
//LIC// version 2.1 of the License, or (at your option) any later version.
//LIC// 
//LIC// This library is distributed in the hope that it will be useful,
//LIC// but WITHOUT ANY WARRANTY; without even the implied warranty of
//LIC// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//LIC// Lesser General Public License for more details.
//LIC// 
//LIC// You should have received a copy of the GNU Lesser General Public
//LIC// License along with this library; if not, write to the Free Software
//LIC// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
//LIC// 02110-1301  USA.
//LIC// 
//LIC// The authors may be contacted at oomph-lib@maths.man.ac.uk.
//LIC// 
//LIC//====================================================================
//Three-dimensional free-surface test case

// C++ includes
#include <iostream>
#include <fstream>
#include <cmath>
#include <typeinfo>
#include <algorithm>
#include <cstdio> 
#include <complex>
 
// The oomphlib headers   
#include "generic.h"
#include "navier_stokes.h"
#include "fluid_interface.h"

// The mesh
#include "meshes/single_layer_cubic_spine_mesh.h"

using namespace std;

using namespace oomph;


//======================================================================
/// Namepspace for global parameters
//======================================================================
namespace Global_Physical_Variables
{

 /// Reynolds number
 double Re;

 /// Womersley = Reynolds times Strouhal
 double ReSt; 
 
 /// Product of Reynolds and Froude number
 double ReInvFr;

 /// Capillary number
 double Ca;  

 /// Direction of gravity
 Vector<double> G(3);

}


//======================================================================
/// Single fluid interface problem
//======================================================================
template<class ELEMENT, class TIMESTEPPER>
class InterfaceProblem : public Problem
{
 
public:

 /// Constructor: Pass number of elements in x and y directions. Also lengths
 /// of the domain in x- and y-directions and the height of the layer

 InterfaceProblem(const unsigned &Nx, const unsigned &Ny, const unsigned &Nz,
                  const double &Lx, const double &Ly, const double &h);
 
 /// Spine heights/lengths are unknowns in the problem so their
 /// values get corrected during each Newton step. However,
 /// changing their value does not automatically change the
 /// nodal positions, so we need to update all of them
 void actions_before_newton_convergence_check(){Bulk_mesh_pt->node_update();}

 //Update before solve is empty
 void actions_before_newton_solve() {}

 /// \short Update after solve can remain empty, because the update 
 /// is performed automatically after every Newton step.
 void actions_after_newton_solve() {}

 ///Fix pressure value l in element e to value p_value
 void fix_pressure(const unsigned &e, const unsigned &l, 
                   const double &pvalue)
  {
   //Fix the pressure at that element
   dynamic_cast<ELEMENT *>(Bulk_mesh_pt->element_pt(e))->
    fix_pressure(l,pvalue);
  }
 

 /// Run an unsteady simulation with specified number of steps
 void unsteady_run(const unsigned& nstep); 

 /// Doc the solution
 void doc_solution(DocInfo& doc_info);
 

private:

 /// Trace file
 ofstream Trace_file;

 /// Axial lengths of domain
 double Lx;

 double Ly;

 /// Pointer to bulk mesh
 SingleLayerCubicSpineMesh<ELEMENT,
                           SpineSurfaceFluidInterfaceElement<ELEMENT> >*
 Bulk_mesh_pt;

 /// Is the domain symmetric in the x-direction? 
 bool Symmetric_in_x;

};


//====================================================================
/// Problem constructor
//====================================================================
template<class ELEMENT, class TIMESTEPPER>
InterfaceProblem<ELEMENT,TIMESTEPPER>::InterfaceProblem
(const unsigned &nx, const unsigned &ny,const unsigned &nz,
 const double &lx, const double &ly, const double& h)
 : Lx(lx), Ly(ly)
{  
 //Allocate the timestepper
 add_time_stepper_pt(new TIMESTEPPER); 

 //Now create the mesh
 Bulk_mesh_pt = new SingleLayerCubicSpineMesh<ELEMENT,
  SpineSurfaceFluidInterfaceElement<ELEMENT> >
  (nx,ny,nz,lx,ly,h,time_stepper_pt());
 // Make bulk mesh the global mesh
 mesh_pt()=Bulk_mesh_pt;
 
 //Pin all nodes on the bottom
 unsigned long n_boundary_node = mesh_pt()->nboundary_node(0);
 for(unsigned long n=0;n<n_boundary_node;n++)
  {
   for(unsigned i=0;i<3;i++)
    {
     mesh_pt()->boundary_node_pt(0,n)->pin(i);
    }
  }

 //On the front and back (y=const) pin in y-direction
 for(unsigned b=1;b<4;b+=2)
  {
   n_boundary_node = mesh_pt()->nboundary_node(b);
   for(unsigned long n=0;n<n_boundary_node;n++)
    {
     mesh_pt()->boundary_node_pt(b,n)->pin(1);
    }
  }

 //On sides pin in x-direction
 for(unsigned b=2;b<5;b+=2)
  {
   n_boundary_node = mesh_pt()->nboundary_node(b);
   for(unsigned long n=0;n<n_boundary_node;n++)
    {
     mesh_pt()->boundary_node_pt(b,n)->pin(0);
    }
  }

 //Create a Data object whose single value stores the
 //external pressure
 Data* external_pressure_data_pt = new Data(1);
 
 // Set and pin the external pressure to some random value
 external_pressure_data_pt->set_value(0,1.31);
 external_pressure_data_pt->pin(0);

 //Complete the problem setup to make the elements fully functional

 //Loop over the elements in the layer
 unsigned n_bulk=Bulk_mesh_pt->nbulk();
 for(unsigned i=0;i<n_bulk;i++)
  {
   //Cast to a fluid element
   ELEMENT *el_pt = dynamic_cast<ELEMENT*>(Bulk_mesh_pt->
                                           bulk_element_pt(i));

   //Set the Reynolds number, etc
   el_pt->re_pt() = &Global_Physical_Variables::Re;
   el_pt->re_st_pt() = &Global_Physical_Variables::ReSt;
   el_pt->re_invfr_pt() = &Global_Physical_Variables::ReInvFr;
   el_pt->g_pt() = &Global_Physical_Variables::G;

   //Assign the time pointer
   el_pt->time_pt() = time_pt();
  }

 //Loop over 2D interface elements and set capillary number and 
 //the external pressure
 unsigned long interface_element_pt_range = Bulk_mesh_pt->ninterface_element();
 for(unsigned i=0;i<interface_element_pt_range;i++)
  {
   //Cast to a interface element
   SpineSurfaceFluidInterfaceElement<ELEMENT>* el_pt = 
    dynamic_cast<SpineSurfaceFluidInterfaceElement<ELEMENT>*>
    (Bulk_mesh_pt->interface_element_pt(i));

   //Set the Capillary number
   el_pt->ca_pt() = &Global_Physical_Variables::Ca;

   //Pass the Data item that contains the single external pressure value
   el_pt->set_external_pressure_data(external_pressure_data_pt);
  }

 //Do equation numbering
 cout << assign_eqn_numbers() << std::endl; 

}

   

//========================================================================
/// Doc the solution
//========================================================================
template<class ELEMENT, class TIMESTEPPER>
void InterfaceProblem<ELEMENT,TIMESTEPPER>::doc_solution(DocInfo& doc_info)
{ 

 ofstream some_file;
 char filename[100];

 // Number of plot points
 unsigned npts=5; 

 //Output the time
 cout << "Time is now " << time_pt()->time() << std::endl;

 // Number of spines
 unsigned nspine=Bulk_mesh_pt->nspine();

 // Doc
 Trace_file << time_pt()->time();
 Trace_file << " "  << Bulk_mesh_pt->spine_pt(0)->height();
 Trace_file << " "  << Bulk_mesh_pt->spine_pt(nspine-1)->height();
 Trace_file << std::endl;


 // Output solution 
 sprintf(filename,"%s/soln%i.dat",doc_info.directory().c_str(),
         doc_info.number());
 some_file.open(filename);
 Bulk_mesh_pt->output(some_file,npts);
 some_file.close();
 
}

 


//=============================================================================
/// Unsteady run with specified number of steps
//=============================================================================
template<class ELEMENT, class TIMESTEPPER>
void InterfaceProblem<ELEMENT,TIMESTEPPER>::unsteady_run(const unsigned& nstep)
{

 // Increase maximum residual
 Problem::Max_residuals=100.0;

 //Distort the mesh
 double epsilon=0.1;
 unsigned Nperiods = 1;
 unsigned Nspine = Bulk_mesh_pt->nspine();
 for(unsigned i=0;i<Nspine;i++)
  {
   double x_value = Bulk_mesh_pt->boundary_node_pt(0,i)->x(0);
   double y_value = Bulk_mesh_pt->boundary_node_pt(0,i)->x(1);
   
   Bulk_mesh_pt->spine_pt(i)->height() = 
    1.0 + epsilon*(cos(2.0*Nperiods*MathematicalConstants::Pi*x_value/Lx)
                   + cos(2.0*Nperiods*MathematicalConstants::Pi*y_value/Ly));

  }

 //Make sure to update 
 Bulk_mesh_pt->node_update();


 // Doc info object
 DocInfo doc_info;

 // Set output directory
 doc_info.set_directory("RESLT");
 doc_info.number()=0;
 
 // Open trace file
 char filename[100];   
 sprintf(filename,"%s/trace.dat",doc_info.directory().c_str());
 Trace_file.open(filename);

 Trace_file << "VARIABLES=\"time\",";
 Trace_file << "\"h<sub>left</sub>\",\"h<sub>right</sub>\"";
 


 //Set value of dt
 double  dt = 0.01;

 //Initialise all time values
 assign_initial_values_impulsive(dt);
  
 //Doc initial solution
 doc_solution(doc_info);

//Loop over the timesteps
 for(unsigned t=1;t<=nstep;t++)
  {
   cout << "TIMESTEP " << t << std::endl;
   
   //Take one fixed timestep
   unsteady_newton_solve(dt);

   // Doc solution
   doc_info.number()++;
   doc_solution(doc_info);
   }

}



//======================================================================
/// Driver code for unsteady two-layer fluid problem. If there are
/// any command line arguments, we regard this as a validation run
/// and perform only two steps.

// In my version we will change nsteps in the programs
//======================================================================
int main(int argc, char *argv[]) 
{

 // Set physical parameters:

 //Set direction of gravity: Vertically downwards
 Global_Physical_Variables::G[0] = 0.0;
 Global_Physical_Variables::G[1] = 0.0;
 Global_Physical_Variables::G[2] = -1.0;
 
 // Womersley number = Reynolds number (St = 1)
 Global_Physical_Variables::ReSt = 5.0;
 Global_Physical_Variables::Re = Global_Physical_Variables::ReSt;
 
 // The Capillary number
 Global_Physical_Variables::Ca = 0.01;
 
 // Re/Fr hierher check what Fr is 
 Global_Physical_Variables::ReInvFr = 0.0;
 
 //Axial lngth of domain
 double lx = 2.0;
 
 double ly = 2.0;
   
 // Number of elements in x- and y-direction
 unsigned nx=5;
 
 unsigned ny = 5;
 
 // Number of elements in layer
 unsigned nz=7;
 
 // Height of layer
 double h=2.0;
 
 //Set up the spine test problem
  InterfaceProblem<SpineElement<QCrouzeixRaviartElement<3> >,BDF<2> >
  problem(nx,ny,nz,lx,ly,h);
  
  // Number of steps: 
   unsigned nstep;
   if(argc > 1)
    {
     // Validation run: Just two steps
     nstep=2;
    }
   else
    {
     // Full run otherwise
     nstep=160;
    }
   
   // Run the unsteady simulation
   problem.unsteady_run(nstep);
}

