#' Add a table footnote
#'
#' The `tab_footnote()` function can make it a painless process to add a
#' footnote to a \pkg{gt} table. There are two components to a footnote: (1) a
#' glyph that is attached to the targeted cell text, and (2) the footnote text
#' (that starts with the corresponding glyph) that is placed in the table's
#' footer area. Each call of `tab_footnote()` will add a different note, and one
#' or more cells can be targeted via the location helper functions (e.g.,
#' [cells_data()], [cells_column_labels()], etc.).
#'
#' The formatting of the footnotes can be controlled through the use of various
#' parameters in the [tab_options()] function:
#'
#' \itemize{ \item `footnote.sep`: allows for a choice of the separator between
#' consecutive footnotes in the table footer. By default, this is set to a
#' linebreak. \item `footnote.glyph`: the set of sequential characters or
#' numbers used to identify the footnotes. \item `footnote.font.size`: the size
#' of the font used in the footnote section. \item `footnote.padding`: the
#' amount of padding to apply between the footnote and source note sections in
#' the table footer. }
#'
#' @inheritParams fmt_number
#' @param footnote The text to be used in the footnote. We can optionally use
#'   the [md()] and [html()] functions to style the text as Markdown or to
#'   retain HTML elements in the footnote text.
#' @param locations The cell or set of cells to be associated with the footnote.
#'   Supplying any of the `cells_*()` helper functions is a useful way to target
#'   the location cells that are associated with the footnote text. These helper
#'   functions are: [cells_title()], [cells_column_labels()], [cells_group()],
#'   [cells_stub()], [cells_data()], and [cells_summary()]. Please see the help
#'   article \link{location_cells} for more information on how these helper
#'   functions can be used. Additionally, we can enclose several `cells_*()`
#'   calls within a `list()` if we wish to link the footnote text to different
#'   types of locations (e.g., cell data values, stub group headings, the table
#'   title, etc.).
#' @return An object of class `gt_tbl`.
#' @examples
#' # Use `sza` to create a gt table; color
#' # the `sza` column using the `data_color()`
#' # function, then, add a footnote to the
#' # `sza` column label explaining what the
#' # color scale signifies
#' tab_1 <-
#'   sza %>%
#'   dplyr::filter(
#'     latitude == 20 &
#'       month == "jan" &
#'       !is.na(sza)
#'   ) %>%
#'   dplyr::select(-latitude, -month) %>%
#'   gt() %>%
#'   data_color(
#'     columns = vars(sza),
#'     colors = scales::col_numeric(
#'       palette = c("white", "yellow", "navyblue"),
#'       domain = c(0, 90))
#'   ) %>%
#'   tab_footnote(
#'     footnote = "Color indicates height of sun.",
#'     locations = cells_column_labels(
#'       columns = vars(sza))
#'   )
#'
#' @section Figures:
#' \if{html}{\figure{man_tab_footnote_1.svg}{options: width=100\%}}
#'
#' @family table-part creation/modification functions
#' @export
tab_footnote <- function(data,
                         footnote,
                         locations) {

  # Resolve into a list of locations
  locations <- as_locations(locations)

  # Resolve the locations of the targeted data cells and append
  # the footnotes
  for (loc in locations) {
    data <- set_footnote(loc, data, process_text(footnote))
  }

  data
}

set_footnote <- function(loc, data, footnote) {
  UseMethod("set_footnote")
}

set_footnote.cells_data <- function(loc, data, footnote) {

  resolved <- resolve_cells_data(data = data, object = loc)

  cols <- resolved$columns
  rows <- resolved$rows

  colnames <- colnames(as.data.frame(data))[cols]

  attr(data, "footnotes_df") <-
    add_location_row(
      data, df_type = "footnotes_df",
      locname = "data", locnum = 5,
      grpname = NA_character_, colname = colnames,
      rownum = rows, text = footnote)

  data
}

set_footnote.cells_stub <- function(loc, data, footnote) {

  resolved <- resolve_cells_stub(data = data, object = loc)

  rows <- resolved$rows

  attr(data, "footnotes_df") <-
    add_location_row(
      data, df_type = "footnotes_df",
      locname = "stub", locnum = 5,
      grpname = NA_character_, colname = NA_character_,
      rownum = rows, text = footnote)

  data
}

set_footnote.cells_column_labels <- function(loc, data, footnote) {

  if (!is.null(loc$columns)) {

    resolved <- resolve_cells_column_labels(data = data, object = loc)

    cols <- resolved$columns

    colnames <- colnames(as.data.frame(data))[cols]

    attr(data, "footnotes_df") <-
      add_location_row(
        data, df_type = "footnotes_df",
        locname = "columns_columns", locnum = 4,
        grpname = NA_character_, colname = colnames,
        rownum = NA_character_, text = footnote)

  } else if (!is.null(loc$groups)) {

    groups <- (loc$groups %>% as.character())[-1]

    attr(data, "footnotes_df") <-
      add_location_row(
        data, df_type = "footnotes_df",
        locname = "columns_groups", locnum = 3,
        grpname = groups, colname = NA_character_,
        rownum = NA_character_, text = footnote)
  }

  data
}

set_footnote.cells_group <- function(loc, data, footnote) {

  groups <- (loc$groups %>% as.character())[-1]

  attr(data, "footnotes_df") <-
    add_location_row(
      data, df_type = "footnotes_df",
      locname = "stub_groups", locnum = 5,
      grpname = groups, colname = NA_character_,
      rownum = NA_character_, text = footnote)

  data
}

set_footnote.cells_title <- function(loc, data, footnote) {

  if ((loc$groups %>% as.character())[-1] == "title") {

    attr(data, "footnotes_df") <-
      add_location_row(
        data, df_type = "footnotes_df",
        locname = "title", locnum = 1,
        grpname = NA_character_, colname = NA_character_,
        rownum = NA_character_, text = footnote)

  } else if ((loc$groups %>% as.character())[-1] == "subtitle") {

    attr(data, "footnotes_df") <-
      add_location_row(
        data, df_type = "footnotes_df",
        locname = "subtitle", locnum = 2,
        grpname = NA_character_, colname = NA_character_,
        rownum = NA_character_, text = footnote)
  }

  data
}

set_footnote.cells_summary <- function(loc, data, footnote) {

  add_summary_location_row(
    loc = loc,
    data = data,
    text = footnote,
    df_type = "footnotes_df"
  )
}

set_footnote.cells_grand_summary <- function(loc, data, footnote) {

  add_grand_summary_location_row(
    loc = loc,
    data = data,
    text = footnote,
    df_type = "footnotes_df"
  )
}

#' @importFrom dplyr bind_rows tibble distinct
#' @noRd
add_location_row <- function(data,
                             df_type,
                             locname,
                             locnum,
                             grpname,
                             colname,
                             rownum,
                             text) {

  dplyr::bind_rows(
    attr(data, df_type, exact = TRUE),
    dplyr::tibble(
      locname = locname, locnum = locnum,
      grpname = grpname, colname = colname,
      rownum = rownum, text = text)) %>%
    dplyr::distinct()
}
