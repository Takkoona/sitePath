#include "pruner.h"

// [[Rcpp::export]]
NumericMatrix getSimilarityMatrix(const ListOf<CharacterVector> &alignedSeqs) {
  int dim = alignedSeqs.size();
  NumericMatrix simMatrix(dim, dim);
  for (int i = 0; i < dim; ++i) {
    for (int j = i; j < dim; ++j) {
      if (i == j) {
        simMatrix(i, j) = 1;
      } else {
        simMatrix(j, i) = simMatrix(i, j) = compare(
          as<std::string>(alignedSeqs[i]),
          as<std::string>(alignedSeqs[j])
        );
      }
    }
  }
  return simMatrix;
}

// [[Rcpp::export]]
SEXP trimTree(
    const ListOf<IntegerVector> &tipPaths, 
    const ListOf<CharacterVector> &alignedSeqs,
    NumericMatrix &simMatrixInput,
    const float similarity, const bool getTips
) {
  std::map<std::pair<int, int>, float> simMatrix;
  int nrow = simMatrixInput.nrow();
  int ncol = simMatrixInput.ncol();
  for (int i = 0; i < nrow; ++i) {
    for (int j = 0; j < ncol; ++j) {
      if (!R_IsNA(simMatrixInput(i, j))) {
        simMatrix[std::make_pair(i + 1, j + 1)] = simMatrixInput(i, j);
      }
    }
  }
  Pruner match(tipPaths, alignedSeqs, similarity, simMatrix);
  if (getTips) {
    return wrap(match.getTips());
  } else {
    return wrap(match.getPaths());
  }
}

// [[Rcpp::export]]
SEXP customTrimTree(
    const ListOf<IntegerVector> &tipPaths, 
    const ListOf<CharacterVector> &alignedSeqs,
    NumericMatrix &simMatrixInput,
    const NumericMatrix &treeEdge,
    const Function &customQualifyFunc,
    const bool getTips
) {
  std::map<std::pair<int, int>, float> simMatrix;
  int nrow = simMatrixInput.nrow();
  int ncol = simMatrixInput.ncol();
  for (int i = 0; i < nrow; ++i) {
    for (int j = 0; j < ncol; ++j) {
      if (!R_IsNA(simMatrixInput(i, j))) {
        simMatrix[std::make_pair(i + 1, j + 1)] = simMatrixInput(i, j);
      }
    }
  }
  std::map< int, std::vector<int> > nodeLink;
  for (int i = 0; i < treeEdge.nrow(); ++i) {
    nodeLink[treeEdge(i, 0)].push_back(treeEdge(i, 1));
  }
  CustomizablePruner match(tipPaths, alignedSeqs, nodeLink, simMatrix, customQualifyFunc);
  if (getTips) {
    return wrap(match.getTips());
  } else {
    return wrap(match.getPaths());
  }
}

// [[Rcpp::export]]
IntegerVector divergentNode(const ListOf<IntegerVector> &paths) {
  std::vector<int> res;
  for (int i = 0; i < paths.size() - 1; i++) {
    for (int j = i + 1; j < paths.size(); j++) {
      IntegerVector::const_iterator q  = paths[i].begin(), s = paths[j].begin();
      do {q++, s++;} while (*q == *s);
      if (--q != paths[i].begin()) res.push_back(*q);
    }
  }
  return wrap(res);
}

// [[Rcpp::export]]
IntegerVector getReference(const std::string &refSeq, const char gapChar) {
  std::vector<int> res;
  for (unsigned int i = 0; i < refSeq.size(); i++) {
    if (refSeq[i] != gapChar) {
      res.push_back(i + 1);
    }
  }
  return wrap(res);
}

// [[Rcpp::export]]
ListOf<IntegerVector> ancestralPaths(const ListOf<IntegerVector> &paths, const int minLen) {
  std::vector<IntegerVector> res;
  for (int i = 0; i < paths.size(); ++i) {
    if (paths[i].size() >= minLen) {
      res.push_back(paths[i][Range(0, minLen - 1)]);
    }
  }
  return wrap(res);
}
