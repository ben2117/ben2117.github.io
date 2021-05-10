
```c#
var dataTable = new DataTable();

new SqlDataAdapter(
          "select Name, Date from ExampleTable"
        , "Connnection String" )
    .Fill(dataTable);

var results = 
    dataTable
    .AsEnumerable()
    .Select(row => new
    {
        Name = row.Field<string>("Name"),
        Date = row.Field<DateTime>("Date")
    })
    .Where(row => row.Date > DateTime.Now.AddDays(-7))
    .ToList(); // This is not an infinite stream of data 
```

Some extensions methods that make working with this a bit nicer

```c#
public static class DataTableHelperExtensions
{
          // Return defaults if column does not exist
          public static T GetField<T>(this DataRow row, string column)
          {
                    return row.Table.Columns.Contains(column) ? (T)row[column]: default;
          }
          
          // Deconstructing lists into head and tail
          public static void Deconstruct<T>(this List<T> list, out T head, out List<T> tail)
	{
		head = list.FirstOrDefault();
		tail = new List<T>(list.Skip(1));
	}
}
```
