
// @HEADER
// ***********************************************************************
// 
//                      Didasko Tutorial Package
//                 Copyright (2005) Sandia Corporation
// 
// Under terms of Contract DE-AC04-94AL85000, there is a non-exclusive
// license for use of this work by or on behalf of the U.S. Government.
// 
// This library is free software; you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 2.1 of the
// License, or (at your option) any later version.
//  
// This library is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//  
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
// USA
//
// Questions about Didasko? Contact Marzio Sala (marzio.sala _AT_ gmail.com)
// 
// ***********************************************************************
// @HEADER

#include "Tpetra_ElementSpace.hpp"
#include "Tpetra_VectorSpace.hpp"
#include "Tpetra_Version.hpp"
#ifdef TPETRA_MPI
#include "Tpetra_MpiPlatform.hpp"
#include "Tpetra_MpiComm.hpp"
#else
#include "Tpetra_SerialPlatform.hpp"
#include "Tpetra_SerialComm.hpp"
#endif
#include "Teuchos_ScalarTraits.hpp"

// \author Marzio Sala, ETHZ/COLAB
//
// \date Last updated on 28-Nov-05

typedef int OrdinalType;
typedef double ScalarType;

int main(int argc, char *argv[]) 
{
#ifdef HAVE_MPI
  MPI_Init(&argc,&argv);
  Tpetra::MpiComm<OrdinalType, ScalarType> Comm(MPI_COMM_WORLD);
#else
  Tpetra::SerialComm<OrdinalType, ScalarType> Comm;
#endif

  // Get zero and one for the OrdinalType
  
  OrdinalType const OrdinalZero = Teuchos::ScalarTraits<OrdinalType>::zero();
  OrdinalType const OrdinalOne  = Teuchos::ScalarTraits<OrdinalType>::one();

  // Get zero and one for the ScalarType
  
  ScalarType const ScalarZero = Teuchos::ScalarTraits<ScalarType>::zero();
  ScalarType const ScalarOne  = Teuchos::ScalarTraits<ScalarType>::one();

  // Creates a vector of size `length', then set the elements values.
  
  OrdinalType length    = OrdinalOne * 10;
  OrdinalType indexBase = OrdinalZero;

  // 1) Creation of a platform
  
#ifdef HAVE_MPI
  const Tpetra::MpiPlatform <OrdinalType, OrdinalType> platformE(MPI_COMM_WORLD);
  const Tpetra::MpiPlatform <OrdinalType, ScalarType> platformV(MPI_COMM_WORLD);
#else
  const Tpetra::SerialPlatform <OrdinalType, OrdinalType> platformE;
  const Tpetra::SerialPlatform <OrdinalType, ScalarType> platformV;
#endif

  // 2) We can now create a space:

  Tpetra::ElementSpace<OrdinalType> elementSpace(length, indexBase, platformE);
  Tpetra::VectorSpace<OrdinalType, ScalarType> 
    vectorSpace(elementSpace, platformV);

  // 3) and the vector, which has type int for the OrdinalType
  //    and double for the ScalarType

  Tpetra::Vector<OrdinalType, ScalarType> v1(vectorSpace);

  // 4) We can now set all the elements of the vector. There are
  //    several way, here we detail some of them. To set all the
  //    elements to the same value, one can do:
  
  v1.setAllToScalar(ScalarOne);
  cout << v1 << endl;

  // The easiest way is to set the elements using the [] operator

  OrdinalType MyLength = elementSpace.getNumMyElements();

  for (OrdinalType i = OrdinalZero ; i < MyLength ; ++i)
    v1[i] = (ScalarType)(10 + i);

  cout << v1;

  // Another way is to extract a view of the internally stored data
  // array.

  OrdinalType NumMyEntries = v1.getNumMyEntries();

  vector<ScalarType*> data(NumMyEntries);
  v1.extractView(&data[0]);

  for (OrdinalType i = OrdinalZero ; i < MyLength ; ++i)
    *(data[i]) = (ScalarType)(100 + i);

  cout << v1 << endl;

  // 5) retrive information about the vector

  OrdinalType NumGlobalEntries = v1.getNumMyEntries();

  ScalarType Norm1     = v1.norm1();
  ScalarType Norm2     = v1.norm2();
  ScalarType NormInf   = v1.normInf();
  ScalarType MinValue  = v1.minValue();
  ScalarType MaxValue  = v1.maxValue();
  ScalarType MeanValue = v1.meanValue();

  if (Comm.getMyImageID() == 0)
  {
    cout << "on proc 0, NumMyEntries = " << NumMyEntries << endl;
    cout << "NumGlobalEntries = " << NumGlobalEntries << endl;
    cout << "|| v ||_1 = " << Norm1 << endl;
    cout << "|| v ||_2 = " << Norm2 << endl;
    cout << "|| v ||_inf = " << NormInf << endl;
    cout << "min v_i = " << MinValue << endl;
    cout << "max_i v_i = " << MaxValue << endl;
    cout << "sum_i (v_i) / NumGlobalEntries = " << MeanValue << endl;
  }

#ifdef HAVE_MPI
  MPI_Finalize() ;
#endif

  return(EXIT_SUCCESS);
}