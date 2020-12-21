say what you will about fluent api's... this is something I wrote to take some ienumerable to csv.

usage would be
```c#
byte[] csv =  
  data
  .Select( i => new { 
      Month_Billed = i.MonthBilled,
  	  Item_Amount = i.Amount
  	})
  .ToCsvProvider()
  .GetAsFile();
```
and implementaion is 

```c#
public class CsvProvider
	{
		private StringBuilder _csv;
		
		public CsvProvider()
		{
			_csv = new StringBuilder();
		}
		public CsvProvider AddCustomHeader(string header)
		{
			if (_csv.Length != 0)
				throw new Exception("Header already exists in csv");
			_csv.Append(header);
			_csv.AppendLine();
			return this;
		}
		public CsvProvider Add<T>(IEnumerable<T> entries)
		{
			entries.ToList().ForEach(e => Add(e));
			return this;
		}
		public CsvProvider Add<T>(T entry)
		{
			if (_csv.Length == 0)
				CreateHeader<T>();

			foreach (var property in typeof(T).GetProperties())
				_csv.Append(property.GetValue(entry, null) + ",");
			_csv.Remove(_csv.Length - 1, 1);
			_csv.AppendLine();
			return this;
		}
		public string GetAsString()
		{
			return _csv.ToString();
		}
		public byte[] GetAsFile()
		{
			return Encoding.ASCII.GetBytes(_csv.ToString());
		}
		private void CreateHeader<T>()
		{
			foreach (var property in typeof(T).GetProperties())
				_csv.Append(property.Name + ",");
			_csv.Remove(_csv.Length - 1, 1);
			_csv.AppendLine();
		}
	}

	public static class CsvProviderExtensions
	{
		public static CsvProvider ToCsvProvider<T>(this IEnumerable<T> contents)
		{
			return new CsvProvider().Add(contents);
		}
	}

```
