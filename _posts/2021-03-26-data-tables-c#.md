
```c#
var dataTable = new DataTable();

new SqlDataAdapter(
          "select Name, Date from ExampleTable"
        , "Connnection String" )
    .Fill(dataTable);

var results = dataTable
    .AsEnumerable()
    .Select(row => new
    {
        Name = row.Field<string>("Name"),
        Date = row.Field<DateTime>("Date"),
    })
    .Where(row => row.Date > DateTime.Now.AddDays(-7));
```
