% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
%BASIS_DATA = GET_MONOMIAL_BASIS(DEGREE,N_VARS) returns all the DEGREE-order
%monomials of polynomials with N_VARS variables. BASIS_DATA contains a cell
%array, BASIS_DATA.MONOMIAL, with the vectors grouped by DEGREE and also 
%BASIS_DATA.MONOMIALS which contains an array with all 
%NCHOOSEK(DEGREE + N_VARS, DEGREE) monomials,
%
% Requirements: DEGREE >= 1, N_VARS >= 1
%
% Examples: BASIS_DATA = get_monomial_basis(2,3)
%    
%        BASIS_DATA = 
%             monomial: {3x1 cell}
%            monomials: [10x3 double]
%
% See also expand_basis.
%
function out = get_monomial_basis(degree,dimension)
out = expand_basis(degree,eye(dimension,'uint32'));


