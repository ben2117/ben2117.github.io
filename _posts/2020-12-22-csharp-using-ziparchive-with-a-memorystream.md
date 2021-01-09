Using zip archive in memory. You should probably consider if this is a good idea. In my case we only have < 10 small pdfs so it ok. 

```c#
using (var memoryStream = new MemoryStream())
{
  using (var archive = new ZipArchive(memoryStream, ZipArchiveMode.Create, true))
  {
      documents.ToList().ForEach(d =>
      {
          var file = archive.CreateEntry($"{d.Name}.pdf");
          using (var entryStream = file.Open())
          using (var binaryWriter = new BinaryWriter(entryStream))
          {
              binaryWriter.Write(d.GetPdf());
          }
      });
  }
}
```
