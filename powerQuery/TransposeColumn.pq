let
    Source =
        (t as table, keepColumnName as list, transposeColumnName as list) =>
            let
                tableWithIndex = AddIndexToBeginning(t, "INDEX_ID"),
                measure =
                    Table.SelectColumns(
                        tableWithIndex,
                        List.Combine(
                            {
                                {
                                    "INDEX_ID"
                                },
                                transposeColumnName
                            }
                        )
                    ),
                measure1 = Table.DemoteHeaders(measure),
                measure2 = Table.Transpose(measure1),
                measure3 =
                    Table.PromoteHeaders(
                        measure2,
                        [PromoteAllScalars = true]
                    ),
                dimension =
                    Table.SelectColumns(
                        tableWithIndex,
                        List.Combine(
                            {
                                {
                                    "INDEX_ID"
                                },
                                keepColumnName
                            }
                        )
                    ),
                dimension1 =
                    Table.AddColumn(
                        dimension,
                        "Measure",
                        each
                            Table.RenameColumns(
                                Table.SelectColumns(
                                    measure3,
                                    {
                                        "INDEX_ID",
                                        Text.From([INDEX_ID])
                                    }
                                ),
                                {
                                    {
                                        "INDEX_ID",
                                        "VALUE_TYPE"
                                    },
                                    {
                                        Text.From([INDEX_ID]),
                                        "VALUE"
                                    }
                                }
                            )
                    ),
                dimension2 =
                    Table.RemoveColumns(
                        dimension1,
                        "INDEX_ID"
                    )
            in
                Table.ExpandTableColumn(
                    dimension2,
                    "Measure",
                    {
                        "VALUE_TYPE",
                        "VALUE"
                    },
                    {
                        "VALUE_TYPE",
                        "VALUE"
                    }
                )
in
    Source