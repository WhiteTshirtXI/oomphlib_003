/* @HEADER@ */
// ************************************************************************
// 
//                              Sundance
//                 Copyright (2005) Sandia Corporation
// 
// Copyright (year first published) Sandia Corporation.  Under the terms 
// of Contract DE-AC04-94AL85000 with Sandia Corporation, the U.S. Government 
// retains certain rights in this software.
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
// Questions? Contact Kevin Long (krlong@sandia.gov), 
// Sandia National Laboratories, Livermore, California, USA
// 
// ************************************************************************
/* @HEADER@ */

#ifndef SUNDANCE_L2PROJECTOR_H
#define SUNDANCE_L2PROJECTOR_H

#include "SundanceDefs.hpp"
#include "SundanceMesh.hpp"
#include "SundanceExpr.hpp"
#include "SundanceDiscreteFunction.hpp"
#include "SundanceDiscreteSpace.hpp"
#include "SundanceLinearProblem.hpp"
#include "SundanceCoordinateSystem.hpp"
#include "PlayaLinearOperatorDecl.hpp"
#include "PlayaLinearSolverDecl.hpp"
#include "PlayaVectorDecl.hpp"
#include "PlayaVectorType.hpp"

namespace Sundance
{
using namespace Playa;
using namespace Teuchos;

/**
 * L2Projector projects an expression onto a DiscreteSpace. 
 */
class L2Projector
{
public:
  /** */
  L2Projector(){;}
  /** */
  L2Projector(const DiscreteSpace& space, 
    const Expr& expr);
  /** */
  L2Projector(const DiscreteSpace& space, 
    const Expr& expr,
    const QuadratureFamily& quad);
  /** */
  L2Projector(const DiscreteSpace& space, 
    const Expr& expr,
    const LinearSolver<double>& solver);
  /** */
  L2Projector(const DiscreteSpace& space, 
    const Expr& expr,
    const LinearSolver<double>& solver,
    const QuadratureFamily& quad);
  /** */
  L2Projector(const DiscreteSpace& space, 
    const CoordinateSystem& coordSys,
    const Expr& expr);
  /** */
  L2Projector(const DiscreteSpace& space, 
    const CoordinateSystem& coordSys,
    const Expr& expr,
    const LinearSolver<double>& solver);

  /** */
  Expr project() const {return prob_.solve(solver_);}

  /** */
  const LinearProblem& prob() const {return prob_;}

private:

  void init(const DiscreteSpace& space,       
    const CoordinateSystem& coordSys,
    const Expr& expr,
    const LinearSolver<double>& solver,
    const QuadratureFamily& quad);
    
  LinearProblem prob_;

  LinearSolver<double> solver_;
    
};
}


#endif
