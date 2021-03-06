#' Add a table header
#'
#' We can add a table header to the \pkg{gt} table with a title and even a
#' subtitle. A table header is an optional table part that is positioned above
#' the column labels. We have the flexibility to use Markdown formatting for the
#' header's title and subtitle. Furthermore, if the table is intended for HTML
#' output, we can use HTML in either of the title or subtitle.
#' @inheritParams fmt_number
#' @param title,subtitle Text to be used in the table title and, optionally, for
#'   the table subtitle. We can elect to use the [md()] and [html()] helper
#'   functions to style the text as Markdown or to retain HTML elements in the
#'   text.
#' @return An object of class `gt_tbl`.
#' @examples
#' # Use `gtcars` to create a gt table;
#' # add a header part to contain a title
#' # and subtitle
#' tab_1 <-
#'   gtcars %>%
#'   dplyr::select(mfr, model, msrp) %>%
#'   dplyr::slice(1:5) %>%
#'   gt() %>%
#'   tab_header(
#'     title = md("Data listing from **gtcars**"),
#'     subtitle = md("`gtcars` is an R dataset")
#'   )
#'
#' @section Figures:
#' \if{html}{\figure{man_tab_header_1.svg}{options: width=100\%}}
#'
#' @family table-part creation/modification functions
#' @export
tab_header <- function(data,
                       title,
                       subtitle = NULL) {

  # Handle the optional `subtitle` text
  if (is.null(subtitle)) {
    subtitle <- ""
  }

  attr(data, "heading") <-
    list(
      title = title,
      subtitle = subtitle)

  data
}

#' Add label text to the stubhead
#'
#' Add a label to the stubhead of a \pkg{gt} table. The stubhead is the lone
#' element that is positioned left of the column labels, and above the stub. If
#' a stub does not exist, then there is no stubhead (so no change will be made
#' when using this function in that case). We have the flexibility to use
#' Markdown formatting for the stubhead label. Furthermore, if the table is
#' intended for HTML output, we can use HTML for the stubhead label.
#' @inheritParams fmt_number
#' @param label The text to be used as the stubhead label We can optionally use
#'   the [md()] and [html()] functions to style the text as Markdown or to
#'   retain HTML elements in the text.
#' @return An object of class `gt_tbl`.
#' @examples
#' # Use `gtcars` to create a gt table; add
#' # a stubhead label to describe what is
#' # in the stub
#' tab_1 <-
#'   gtcars %>%
#'   dplyr::select(model, year, hp, trq) %>%
#'   dplyr::slice(1:5) %>%
#'   gt(rowname_col = "model") %>%
#'   tab_stubhead_label(label = "car")
#'
#' @section Figures:
#' \if{html}{\figure{man_tab_stubhead_label_1.svg}{options: width=100\%}}
#'
#' @family table-part creation/modification functions
#' @export
tab_stubhead_label <- function(data,
                               label) {

  attr(data, "stubhead_label") <-
    list(stubhead_label = label)

  data
}

#' Add a row group
#'
#' Create a row group with a collection of rows. This requires specification of
#' the rows to be included, either by supplying row labels, row indices, or
#' through use of a select helper function like `starts_with()`.
#' @inheritParams fmt_number
#' @param group The name of the row group. This text will also serve as the row
#'   group label.
#' @param rows The rows to be made components of the row group. Can either be a
#'   vector of row captions provided `c()`, a vector of row indices, or a helper
#'   function focused on selections. The select helper functions are:
#'   [starts_with()], [ends_with()], [contains()], [matches()], [one_of()], and
#'   [everything()].
#' @param others An option to set a default row group label for any rows not
#'   formally placed in a row group named by `group` in any call of
#'   `tab_row_group()`. A separate call to `tab_row_group()` with only a value
#'   to `others` is possible and makes explicit that the call is meant to
#'   provide a default row group label. If this is not set and there are rows
#'   that haven't been placed into a row group (where one or more row groups
#'   already exist), those rows will be automatically placed into a row group
#'   without a label.
#' @return An object of class `gt_tbl`.
#' @examples
#' # Use `gtcars` to create a gt table and
#' # add two row groups with the labels:
#' # `numbered` and `NA` (a group without
#' # a title, or, the rest)
#' tab_1 <-
#'   gtcars %>%
#'   dplyr::select(model, year, hp, trq) %>%
#'   dplyr::slice(1:8) %>%
#'   gt(rowname_col = "model") %>%
#'   tab_row_group(
#'     group = "numbered",
#'     rows = matches("^[0-9]")
#'   )
#'
#' # Use `gtcars` to create a gt table;
#' # add two row groups with the labels
#' # `powerful` and `super powerful`: the
#' # distinction being `hp` lesser or
#' # greater than `600`
#' tab_2 <-
#'   gtcars %>%
#'   dplyr::select(model, year, hp, trq) %>%
#'   dplyr::slice(1:8) %>%
#'   gt(rowname_col = "model") %>%
#'   tab_row_group(
#'     group = "powerful",
#'     rows = hp <= 600
#'   ) %>%
#'   tab_row_group(
#'     group = "super powerful",
#'     rows = hp > 600
#'   )
#'
#' @section Figures:
#' \if{html}{\figure{man_tab_row_group_1.svg}{options: width=100\%}}
#'
#' \if{html}{\figure{man_tab_row_group_2.svg}{options: width=100\%}}
#'
#' @family table-part creation/modification functions
#' @import rlang
#' @export
tab_row_group <- function(data,
                          group = NULL,
                          rows = NULL,
                          others = NULL) {

  # Capture the `rows` expression
  row_expr <- rlang::enquo(rows)

  # Create a row group if a `group` is provided
  if (!is.null(group)) {

    # Get the `stub_df` data frame from `data`
    stub_df <- attr(data, "stub_df", exact = TRUE)

    # Resolve the row numbers using the `resolve_vars` function
    resolved_rows_idx <-
      resolve_data_vals_idx(
        var_expr = !!row_expr,
        data = data,
        vals = stub_df$rowname
      )

    # Place the `group` label in the `groupname` column
    # `stub_df`
    attr(data, "stub_df")[resolved_rows_idx, "groupname"] <-
      process_text(group[1])

    # Insert the group into the `arrange_groups` component
    if (!("arrange_groups" %in% names(attributes(data)))) {

      if (any(is.na(attr(data, "stub_df", exact = TRUE)$groupname))) {

        attr(data, "arrange_groups") <-
          list(groups = c(process_text(group[1]), NA_character_))

      } else {
        attr(data, "arrange_groups") <-
          list(groups = process_text(group[1]))
      }

    } else {

      if (any(is.na(attr(data, "stub_df")$groupname))) {

        attr(data, "arrange_groups")[["groups"]] <-
          c(attr(data, "arrange_groups", exact = TRUE)[["groups"]],
            process_text(group[1]), NA_character_) %>%
          unique()

      } else {
        attr(data, "arrange_groups")[["groups"]] <-
          c(attr(data, "arrange_groups", exact = TRUE)[["groups"]],
            process_text(group[1]))
      }
    }
  }

  # Set a name for the `others` group if a
  # name is provided
  if (!is.null(others)) {
    attr(data, "others_group") <- list(others = process_text(others[1]))
  }

  data
}

#' Add a spanner column label
#'
#' Set a spanner column label by mapping it to columns already in the table.
#' This label is placed above one or more column labels, spanning the width of
#' those columns and column labels.
#' @inheritParams fmt_number
#' @param label The text to use for the spanner column label.
#' @param columns The columns to be components of the spanner heading.
#' @param gather An option to move the specified `columns` such that they are
#'   unified under the spanner column label. Ordering of the moved-into-place
#'   columns will be preserved in all cases.
#' @return An object of class `gt_tbl`.
#' @examples
#' # Use `gtcars` to create a gt table;
#' # Group several columns related to car
#' # performance under a spanner column
#' # with the label `performance`
#' tab_1 <-
#'   gtcars %>%
#'   dplyr::select(
#'     -mfr, -trim, bdy_style, drivetrain,
#'     -drivetrain, -trsmn, -ctry_origin
#'   ) %>%
#'   dplyr::slice(1:8) %>%
#'   gt(rowname_col = "model") %>%
#'   tab_spanner(
#'     label = "performance",
#'     columns = vars(
#'       hp, hp_rpm, trq, trq_rpm,
#'       mpg_c, mpg_h)
#'   )
#'
#' @section Figures:
#' \if{html}{\figure{man_tab_spanner_1.svg}{options: width=100\%}}
#'
#' @family table-part creation/modification functions
#' @export
tab_spanner <- function(data,
                        label,
                        columns,
                        gather = TRUE) {
  checkmate::assert_character(
    label, len = 1, any.missing = FALSE, null.ok = FALSE)

  columns <- enquo(columns)

  # Get the columns supplied in `columns` as a character vector
  column_names <- resolve_vars(var_expr = !!columns, data = data)

  # Get the `grp_labels` list from `data`
  grp_labels <- attr(data, "grp_labels", exact = TRUE)

  # Apply the `label` value to the relevant components
  # of the `grp_labels` list
  grp_labels[column_names] <- label

  # Set the `grp_labels` attr with the `grp_labels` object
  attr(data, "grp_labels") <- grp_labels

  # Gather columns not part of the group of columns under
  # the spanner heading
  if (gather && length(column_names) > 1) {

    # Extract the internal `boxh_df` table
    boxh_df <- attr(data, "boxh_df", exact = TRUE)

    # Get the sequence of columns available in `boxh_df`
    all_columns <- colnames(boxh_df)

    # Get the vector positions of the `columns` in
    # `all_columns`
    matching_vec <-
      match(column_names, all_columns) %>%
      sort() %>%
      unique()

    # Get a vector of column names
    columns_sorted <- all_columns[matching_vec]

    # Move columns into place
    data <-
      data %>%
      cols_move(
        columns = columns_sorted[-1],
        after = columns_sorted[1]
      )
  }

  data
}

#' Add a source note citation
#'
#' Add a source note to the footer part of the \pkg{gt} table. A source note is
#' useful for citing the data included in the table. Several can be added to the
#' footer, simply use multiple calls of `tab_source_note()` and they will be
#' inserted in the order provided. We can use Markdown formatting for the note,
#' or, if the table is intended for HTML output, we can include HTML formatting.
#' @inheritParams fmt_number
#' @param source_note Text to be used in the source note. We can optionally use
#'   the [md()] and [html()] functions to style the text as Markdown or to
#'   retain HTML elements in the text.
#' @return An object of class `gt_tbl`.
#' @examples
#' # Use `gtcars` to create a gt table;
#' # add a source note to the table
#' # footer that cites the data source
#' tab_1 <-
#'   gtcars %>%
#'   dplyr::select(mfr, model, msrp) %>%
#'   dplyr::slice(1:5) %>%
#'   gt() %>%
#'   tab_source_note(
#'     source_note = "From edmunds.com"
#'   )
#'
#' @section Figures:
#' \if{html}{\figure{man_tab_source_note_1.svg}{options: width=100\%}}
#'
#' @family table-part creation/modification functions
#' @export
tab_source_note <- function(data,
                            source_note) {

  if ("source_note" %in% names(attributes(data))) {

    attr(data, "source_note") <-
      c(attr(data, "source_note", exact = TRUE),
        list(source_note))

  } else {

    attr(data, "source_note") <-
      list(source_note)
  }

  data
}
