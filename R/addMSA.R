#' @importFrom ape read.tree
#' @export
ape::read.tree

#' @rdname addMSA
#' @name phyMSAmatched
#' @title Prepare data for sitePath analysis
#' @description sitePath requires both tree and sequence alignment to do the
#'   analysis. \code{addMSA} wraps \code{\link{read.alignment}} function in
#'   \code{\link{seqinr}} package and helps match names in tree and sequence
#'   alignment. Either provide the file path to an alignment file and its format
#'   or an alignment object from the return of \code{\link{read.alignment}}
#'   function. If both the file path and alignment object are given, the
#'   function will use the sequence in the alignment file.
#' @param tree A \code{\link{phylo}} object. This commonly can be from tree
#'   parsing function in \code{\link{ape}} or \code{\link{ggtree}}. All the
#'   \code{tip.label} should be found in the sequence alignment. The tree is
#'   supposed to fully resolved (bifurcated) and will be resolved by
#'   \code{\link{multi2di}} if \code{\link{is.binary}} gives \code{FALSE}.
#' @param msaPath The file path to the multiple sequence alignment file.
#' @param msaFormat The format of the multiple sequence alignment file. The
#'   internal uses the \code{\link{read.alignment}} from \code{\link{seqinr}}
#'   package to parse the sequence alignment. The default is "fasta" and it also
#'   accepts "clustal", "phylip", "mase", "msf".
#' @param alignment An \code{alignment} object. This commonly can be from
#'   sequence parsing function in the \code{\link{seqinr}} package. Sequence
#'   names in the alignment should include all \code{tip.label} in the tree
#' @param seqType The type of the sequence in the alignment file. The default is
#'   "AA" for amino acid. The other options are "DNA" and "RNA".
#' @return Since 1.5.12, the function returns a \code{phyMSAmatched} object to
#'   avoid S3 methods used on \code{phylo} (better encapsulation).
#' @seealso \code{\link{read.alignment}}
#' @importFrom ape multi2di is.binary
#' @importFrom seqinr read.alignment
#' @importFrom methods is
#' @export
#' @examples
#' data(zikv_tree)
#' msaPath <- system.file('extdata', 'ZIKV.fasta', package = 'sitePath')
#' addMSA(zikv_tree, msaPath = msaPath, msaFormat = 'fasta')
addMSA <- function(tree,
                   msaPath = "",
                   msaFormat = c("fasta", "clustal", "phylip", "mase", "msf"),
                   alignment = NULL,
                   seqType = c("AA", "DNA", "RNA")) {
    # String as the placeholder for the 'phyMSAmatched' object
    # Might be using S4 class in the later version
    res <- "This is a 'phyMSAmatched' object."
    class(res) <- "phyMSAmatched"
    # Read alignment from the file or check the class of 'alignment'
    if (file.exists(msaPath)) {
        alignment <- read.alignment(file = msaPath,
                                    format = match.arg(msaFormat))
    } else if (is.null(alignment)) {
        stop("Alignment file \"", msaPath, "\" does not exist.")
    } else if (!is(alignment, "alignment")) {
        stop("\"alignment\" is not class alignment.")
    }
    # Set 'alignment' attribute
    align <- toupper(alignment[["seq"]])
    names(align) <- alignment[["nam"]]
    attr(res, "align") <- align
    # Set the sequence type
    attr(res, "seqType") <- match.arg(seqType)
    # Set 'tree' attribute
    if (!is.binary(tree)) {
        tree <- multi2di(tree, random = FALSE)
        message(
            "The \"tree\" object is not bifurcated ",
            "and resolved by \"multi2di\" function."
        )
    }
    attr(res, "tree") <- tree
    # Use the numbering of MSA as the default site numbering
    res <- setSiteNumbering.phyMSAmatched(res, NULL, NULL)
    return(res)
}

#' @export
print.phyMSAmatched <- function(x, ...) {
    cat(x, "\n")
}