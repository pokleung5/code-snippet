
# Power Query Snippet

## AddIndexToBeginning

- Simply add an index column and reorder it to the leftmost.

### Example: TransposeColumn(t, "Index")
|A|B|C|D|
|:--:|:--:|:--:|:--:|
|1|2|3|4|
|5|6|7|8|
|9|0|1|2|

|Index|A|B|C|D|
|:--:|:--:|:--:|:--:|:--:|
|0|1|2|3|4|
|1|5|6|7|8|
|2|9|0|1|2|

## TransposeColumn

- Transpose part of the table and expand to the rest.

### Example: TransposeColumn(t, {"A", "B"}, {"C", "D"})
|A|B|C|D|
|:--:|:--:|:--:|:--:|
|1|2|3|4|
|5|6|7|8|
|9|0|1|2|

|A|B|VALUE_TYPE|Value|
|:--:|:--:|:--:|:--:|
|1|2|C|3|
|1|2|D|4|
|5|6|C|7|
|5|6|D|8|
|9|0|C|1|
|9|0|D|2|



