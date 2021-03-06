% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/modify_columns.R
\name{cols_merge_uncert}
\alias{cols_merge_uncert}
\title{Merge two columns to a value & uncertainty column}
\usage{
cols_merge_uncert(data, col_val, col_uncert)
}
\arguments{
\item{data}{A table object that is created using the \code{\link[=gt]{gt()}} function.}

\item{col_val}{A single column name that contains the base values.}

\item{col_uncert}{A single column name that contains the uncertainty values.}
}
\value{
An object of class \code{gt_tbl}.
}
\description{
The \code{cols_merge_uncert()} function is a specialized variant of the
\code{\link[=cols_merge]{cols_merge()}} function. It operates by taking a base value column
(\code{col_val}) and an uncertainty column (\code{col_uncert}) and merges them into a
single column. What results is a column with values and associated
uncertainties (e.g., \code{12.0 ± 0.1}), and, the column specified in \code{col_uncert}
is dropped from the output table.
}
\details{
This function could be somewhat replicated using \code{\link[=cols_merge]{cols_merge()}}, however,
\code{cols_merge_uncert()} employs the following specialized semantics for \code{NA}
handling:

\enumerate{

\item \code{NA}s in \code{col_val} result in missing values for the merged
column (e.g., \code{NA} + \code{0.1} = \code{NA})

\item \code{NA}s in \code{col_uncert} (but not \code{col_val}) result in
base values only for the merged column (e.g.,
\code{12.0} + \code{NA} = \code{12.0})

\item \code{NA}s both \code{col_val} and \code{col_uncert} result in
missing values for the merged column (e.g., \code{NA} + \code{NA} =
\code{NA})
}

Any resulting \code{NA} values in the \code{col_val} column following the merge
operation can be easily formatted using the \code{\link[=fmt_missing]{fmt_missing()}} function.

This function is part of a set of three column-merging functions. The other
two are the general \code{\link[=cols_merge]{cols_merge()}} function and the specialized
\code{\link[=cols_merge_range]{cols_merge_range()}} function. These functions operate similarly, where the
second column specified is dropped from the output table. For all of the
\code{cols_merge*()} functions, column removal occurs late in the rendering
lifecycle so those secondary columns are still usable as column references
(e.g., inside expressions provided to \code{rows} in the \code{fmt*()} functions).
}
\section{Figures}{

\if{html}{\figure{man_cols_merge_uncert_1.svg}{options: width=100\%}}
}

\examples{
# Use `exibble` to create a gt table,
# keeping only the `currency` and `num`
# columns; merge columns into one with
# a base value and uncertainty (after
# formatting the `num` column)
tab_1 <-
  exibble \%>\%
  dplyr::select(currency, num) \%>\%
  dplyr::slice(1:7) \%>\%
  gt() \%>\%
  fmt_number(
    columns = vars(num),
    decimals = 3,
    use_seps = FALSE
  ) \%>\%
  cols_merge_uncert(
    col_val = vars(currency),
    col_uncert = vars(num)
  ) \%>\%
  cols_label(
    currency = "value + uncert.")

}
\seealso{
Other column modification functions: \code{\link{cols_align}},
  \code{\link{cols_hide}}, \code{\link{cols_label}},
  \code{\link{cols_merge_range}}, \code{\link{cols_merge}},
  \code{\link{cols_move_to_end}},
  \code{\link{cols_move_to_start}},
  \code{\link{cols_move}}, \code{\link{cols_split_delim}}
}
\concept{column modification functions}
