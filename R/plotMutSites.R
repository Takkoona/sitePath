#' @importFrom stats median
#' @importFrom ape getMRCA Nnode
#' @importFrom ggplot2 ggplot geom_point geom_tile theme
#' @importFrom ggplot2 element_blank element_rect element_line
#' @importFrom ggplot2 scale_color_manual scale_fill_manual scale_x_continuous
#' @importFrom ggplot2 scale_size GeomSegment
#' @importFrom aplot insert_left
#' @importFrom ggtree geom_tiplab geom_point2

#' @rdname plotMutSites
#' @title Plot tree and mutation sites
#' @description The mutated sites for each tip in a phylogenetic tree will be
#'   represented as colored dots positioned by their site number.
#' @param x An \code{\link{SNPsites}} object.
#' @param showTips Whether to plot the tip labels. The default is \code{FALSE}.
#' @param ... Other arguments
#' @return A tree plot with SNP as dots for each tip.
#' @export
#' @examples
#' data(zikv_tree_reduced)
#' data(zikv_align_reduced)
#' tree <- addMSA(zikv_tree_reduced, alignment = zikv_align_reduced)
#' plotMutSites(SNPsites(tree))
plotMutSites <- function(x, ...) {
    UseMethod("plotMutSites")
}

#' @rdname plotMutSites
#' @export
plotMutSites.SNPsites <- function(x, showTips = FALSE, ...) {
    phyMSAmatched <- attr(x, "phyMSAmatched")
    # Use 'ggtree' to make tree plot
    tree <- as.phylo(phyMSAmatched)
    treePlot <- ggtree(tree)
    if (showTips) {
        treePlot <- treePlot + geom_tiplab()
    }
    allSNP <- attr(x, "allSNP")
    seqType <- attr(phyMSAmatched, "seqType")
    snpPlot <- .createSNPplot(
        allSNP = allSNP,
        seqType = seqType,
        allTreeTips = tree[["tip.label"]],
        allSiteNames = attr(phyMSAmatched, "msaNumbering")
    )
    # Combine the two plots and return
    return(insert_left(snpPlot, treePlot, 2))
}

.createSNPplot <- function(allSNP,
                           seqType,
                           allTreeTips,
                           allSiteNames,
                           snpColors = NULL,
                           dotSize = NULL,
                           lineSize = NULL) {
    if (is.null(dotSize)) {
        dotSize <- 1
    }
    if (is.null(lineSize)) {
        lineSize <- 0.2
    }
    allSNPsites <- sort(unique(allSNP[["Pos"]]))
    placeHolder <- data.frame("Accession" = allTreeTips,
                              "Pos" = 0,
                              "SNP" = "hide")
    allSNP <- rbind(allSNP, placeHolder)
    placeHolderTip <- allTreeTips[1]
    existingSites <-
        allSNP[which(allSNP[["Accession"]] == placeHolderTip), "Pos"]
    allSites <- seq_along(allSiteNames)
    placeHolder <- data.frame(
        "Accession" = placeHolderTip,
        "Pos" = setdiff(allSites, existingSites),
        "SNP" = "hide"
    )
    allSNP <- rbind(allSNP, placeHolder)
    # Specify the color of mutations by pre-defined color set.
    if (is.null(snpColors)) {
        snpColors <- .siteColorScheme(seqType)
    }
    # Use 'ggplot' to make SNP plot as dots
    snpPlot <- ggplot(allSNP, aes(x = Pos,
                                  y = Accession,
                                  fill = SNP)) +
        geom_point(
            shape = 23,
            size = dotSize,
            color = "white",
            stroke = 0
        ) +
        scale_fill_manual(values = snpColors, na.translate = FALSE) +
        scale_x_continuous(breaks = allSNPsites) +
        theme(
            axis.title.x = element_blank(),
            axis.text.x = element_blank(),
            axis.ticks.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank(),
            panel.background = element_rect(fill = "white"),
            panel.grid.major.x = element_line(
                color = "grey",
                linetype = 3,
                size = lineSize
            ),
            legend.position = "none"
        )
    return(snpPlot)
}

#' @rdname plotMutSites
#' @export
plotMutSites.lineagePath <- function(x, ...) {
    extraArgs <- list(...)
    rootNode <- attr(x, "rootNode")
    allSiteNames <- seq_along(attr(x, "msaNumbering"))
    tree <- as.phylo(x)
    allTreeTips <- tree[["tip.label"]]
    snp <- SNPsites(x, useAllSites = TRUE)
    snpPlot <- .createSNPplot(
        allSNP = attr(snp, "allSNP"),
        seqType = attr(x, "seqType"),
        allTreeTips = allTreeTips,
        allSiteNames = allSiteNames,
        dotSize = extraArgs[["dotSize"]],
        lineSize = extraArgs[["lineSize"]]
    )
    terminalNodes <- vapply(
        X = x,
        FUN = function(path) {
            tips <- attr(path, "tips")
            getMRCA(tree, tips)
        },
        FUN.VALUE = integer(1)
    )
    terminalTips <- lapply(terminalNodes, function(node) {
        tips <- .childrenTips(tree, node)
        allTreeTips[tips]
    })
    relevantTips <- unlist(terminalTips)
    middlePos <- rep(median(allSiteNames), length(relevantTips))
    snpPlot <- snpPlot +
        geom_tile(
            data = data.frame("middlePos" = middlePos,
                              "relevantTips" = relevantTips),
            mapping = aes(
                x = middlePos,
                y = relevantTips,
                width = max(allSiteNames)
            ),
            fill = "red",
            alpha = 0.5,
            inherit.aes = FALSE
        )
    nNodes <- Nnode(tree, internal.only = FALSE)
    pathNodes <- unique(unlist(x))
    # Set lineage nodes and non-lineage nodes as separate group
    group <- rep(1, times = nNodes)
    group[pathNodes] <- 0
    group <- factor(group)
    # Set line size
    size <- rep(1, times = nNodes)
    size[pathNodes] <- 2
    treePlot <- ggtree(tree, aes(color = group, size = size)) +
        geom_point2(aes(subset = node %in% c(rootNode, terminalNodes)),
                    color = c("blue", rep("red", length(terminalNodes))),
                    size = 3) +
        scale_color_manual(values = c("blue", "black")) +
        scale_size(range = c(GeomSegment[["default_aes"]][["size"]], 1.5)) +
        theme(legend.position = "none")
    widthRatio <- extraArgs[["widthRatio"]]
    if (is.null(widthRatio)) {
        widthRatio <- 2
    }
    return(insert_left(snpPlot, treePlot, widthRatio))
}

#' @rdname plotMutSites
#' @export
plotMutSites.parallelSites <- function(x, ...) {
    return(plot.parallelSites(x, ...))
}

#' @rdname plotMutSites
#' @export
plotMutSites.fixationSites <- function(x, ...) {
    paths <- attr(x, "paths")
    snpPlot <- .createSNPplot(
        allSNP = attr(paths, "allSNP"),
        seqType = attr(paths, "seqType"),
        allTreeTips = as.phylo(paths)[["tip.label"]],
        allSiteNames = attr(paths, "msaNumbering")
    )
    treePlot <- plot(x, ...)
    return(insert_left(snpPlot, treePlot, 2))
}

#' @rdname plotMutSites
#' @param widthRatio The width ratio between tree plot and SNP plot
#' @param fontSize The font size of the mutation label in tree plot
#' @param dotSize The dot size of SNP in SNP plot
#' @param lineSize The background line size in SNP plot
#' @export
plotMutSites.paraFixSites <- function(x,
                                      widthRatio = 0.75,
                                      fontSize = 3.88,
                                      dotSize = 1,
                                      lineSize = 0.5,
                                      ...) {
    paths <- attr(x, "paths")
    seqType <- attr(paths, "seqType")
    tree <- as.phylo(paths)
    # The grouping of the tips by lineages
    .node <- groupTips.lineagePath(paths)
    grp <- names(.node)
    grp <- grp[which(grp != "0")]
    groupColors <-
        colorRampPalette(brewer.pal(9, "Set1"))(length(grp))
    names(groupColors) <- grp
    groupColors["0"] <- "black"
    groupColors["hide"] <- NA
    # Assume there is no result
    treePlot <- NULL
    snpPlot <- NULL
    # Test if 'x' contains 'fixSites' or 'paraSites'
    fixSites <- attr(x, "fixSites")
    if (!is.null(fixSites)) {
        fixSites <- as.treedata.fixationSites(fixSites, .node = .node)
        treePlot <- ggtree(fixSites, aes(color = group)) +
            scale_color_manual(values = groupColors) +
            theme(legend.position = "none") +
            geom_label_repel(
                aes(x = branch, label = SNPs),
                fill = "lightgreen",
                color = "black",
                min.segment.length = 0,
                na.rm = TRUE,
                size = fontSize,
                ...
            )
    }
    allSNP <- attr(x, "allSNP")[, c("Accession", "Pos")]
    if (!is.null(allSNP)) {
        snpGroup <- do.call(rbind, lapply(names(.node), function(n) {
            data.frame("Accession" = .node[[n]],
                       "SNP" = n)
        }))
        allSNP <- merge.data.frame(
            x = allSNP,
            y = snpGroup,
            by = "Accession",
            all.x = TRUE
        )
        snpPlot <- .createSNPplot(
            allSNP = allSNP,
            seqType = seqType,
            allTreeTips = tree[["tip.label"]],
            allSiteNames = attr(paths, "msaNumbering"),
            snpColors = groupColors,
            dotSize = dotSize,
            lineSize = lineSize
        )
    }
    if (is.null(treePlot)) {
        treePlot <- plot.lineagePath(paths)
        if (is.null(snpPlot)) {
            return(treePlot)
        } else {
            return(insert_left(snpPlot, treePlot, widthRatio))
        }
    } else {
        if (is.null(snpPlot)) {
            return(treePlot)
        } else {
            return(insert_left(snpPlot, treePlot, widthRatio))
        }
    }
}
