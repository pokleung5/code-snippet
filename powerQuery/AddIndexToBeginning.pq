let
    Source =
        (t as table, indexName as text) =>
            let
                columnNames =
                    List.Combine(
                        {
                            {
                                indexName
                            },
                            Table.ColumnNames(t)
                        }
                    ),
                tableWithIndex = Table.AddIndexColumn(t, indexName, 0, 1)
            in
                Table.ReorderColumns(
                    tableWithIndex,
                    columnNames
                )
in
    Source