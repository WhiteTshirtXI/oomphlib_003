/*
// @HEADER
// ************************************************************************
//             FEI: Finite Element Interface to Linear Solvers
//                  Copyright (2005) Sandia Corporation.
//
// Under the terms of Contract DE-AC04-94AL85000 with Sandia Corporation, the
// U.S. Government retains certain rights in this software.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
// 1. Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the Corporation nor the names of the
// contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY SANDIA CORPORATION "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SANDIA CORPORATION OR THE
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Questions? Contact Alan Williams (william@sandia.gov) 
//
// ************************************************************************
// @HEADER
*/


#ifndef _snl_fei_FEMatrixTraits_hpp_
#define _snl_fei_FEMatrixTraits_hpp_

#include <fei_macros.hpp>

namespace snl_fei {
  /** Internal implementation matrix traits. Define a "template" for accessing
      matrix data.
      Provide function stubs for default type "T", which will catch the
      use of any matrix type for which specialized traits have not been defined.
  */
  template<typename T>
  struct FEMatrixTraits {

    /** Return a string type-name for the underlying matrix */
    static const char* typeName()
      { return("unsupported"); }

    /** Reset (zero) the matrix.
     */
    static int reset(T* mat)
      { return(-1); }

    /** Sum an element-matrix contribution into the matrix object */
    static int sumInElemMatrix(T* mat,
			       int elemBlockID,
			       int elemID,
			       int numNodes,
			       const int* nodeNumbers,
			       const int* dofPerNode,
             const int* dof_ids,
			       const double *const * coefs)
      { return(-1); }

    /** Enforce Dirichlet boundary conditions on the matrix object */
    static int setDirichletBCs(T* mat,
			       int numBCs,
			       const int* nodeNumbers,
			       const int* dof_ids,
			       const double* values)
      { return(-1); }

  };//class FEMatrixTraits
}//namespace snl_fei

#endif // _snl_fei_FEMatrixTraits_hpp_