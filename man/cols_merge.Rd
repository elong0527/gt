% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/modify_columns.R
\name{cols_merge}
\alias{cols_merge}
\title{Merge two columns to a single column}
\usage{
cols_merge(data, col_1, col_2, pattern = "{1} {2}")
}
\arguments{
\item{data}{A table object that is created using the \code{\link[=gt]{gt()}} function.}

\item{col_1}{A retained column that contains values to be merged with those
in \code{col_2}.}

\item{col_2}{A column that contains values to be merged with those in
\code{col_1}. This column will be discarded but is still useful as a reference
in other \pkg{gt} functions.}

\item{pattern}{A formatting pattern that specifies the arrangement of the
\code{col_1} and \code{col_1} values and any string literals. The \code{col_1} column is
represented as \code{{1}} whereas \code{col_2} is \code{{2}}. All other characters are
taken to be string literals.}
}
\value{
An object of class \code{gt_tbl}.
}
\description{
This function takes any two columns and merges them into a single column,
using a pattern that specifies how the values in the data cells are combined.
We specify the columns to merge together in the \code{col_1} and \code{col_2} arguments
and the string-combining pattern is specified in \code{pattern}. The column that
is retained is that of \code{col_1} whereas the column specified in \code{col_2} is
dropped from the output table.
}
\details{
There are two other column-merging functions that offer specialized behavior
that is optimized for common table tasks: \code{\link[=cols_merge_range]{cols_merge_range()}} and
\code{\link[=cols_merge_uncert]{cols_merge_uncert()}}. These functions operate similarly, where the second
column specified is dropped from the output table. For all of the
\code{cols_merge*()} functions, column removal occurs late in the rendering
lifecycle so those secondary columns are still usable as column references
(e.g., inside expressions provided to \code{rows} in the \code{fmt*()} functions).
}
\section{Figures}{

\if{html}{\figure{man_cols_merge_1.svg}{options: width=100\%}}
}

\examples{
# Use `sp500` to create a gt table;
# merge the `open` & `close` columns
# together, and, the `low` & `high`
# columns (putting an em dash between
# both); rename the columns
tab_1 <-
  sp500 \%>\%
  dplyr::slice(50:55) \%>\%
  dplyr::select(-volume, -adj_close) \%>\%
  gt() \%>\%
  cols_merge(
    col_1 = vars(open),
    col_2 = vars(close),
    pattern = "{1}&mdash;{2}"
  ) \%>\%
  cols_merge(
    col_1 = vars(low),
    col_2 = vars(high),
    pattern = "{1}&mdash;{2}"
  ) \%>\%
  cols_label(
    open = "open/close",
    low = "low/high"
  )

}
\seealso{
Other column modification functions: \code{\link{cols_align}},
  \code{\link{cols_hide}}, \code{\link{cols_label}},
  \code{\link{cols_merge_range}},
  \code{\link{cols_merge_uncert}},
  \code{\link{cols_move_to_end}},
  \code{\link{cols_move_to_start}},
  \code{\link{cols_move}}, \code{\link{cols_split_delim}}
}
\concept{column modification functions}
