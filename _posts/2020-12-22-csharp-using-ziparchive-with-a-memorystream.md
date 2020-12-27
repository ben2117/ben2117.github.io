
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
  
  Response.Clear();
  Response.ContentType = "application/zip";
  Response.Cache.SetCacheability(HttpCacheability.Private);
  Response.Expires = -1;
  Response.Buffer = true;
  Response.AddHeader("Content-Disposition", "attachment;FileName=\"Documents.zip\"");
  Response.BinaryWrite(memoryStream.ToArray());
  Response.Flush();
  Response.End();
}
```
