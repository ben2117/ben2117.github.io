## Client Side

### Html Form 

```html
<script src="https://www.google.com/recaptcha/api.js"></script>

<form id="contactForm" action="Home/Contact" method="post">

            <input type="text" name="name" placeholder="name" >
            <input type="number" name="phone" placeholder="phone" >
            <input type="email" name="email" placeholder="email" >
            <input id="recaptchaField" type="hidden" name="recaptcha" />
            <textarea name="message"></textarea>

        <button data-sitekey="public recaptcha key"
                data-callback='onSubmit'
                data-action='submit'
                class="g-recaptcha">
            Enquire
        </button>
</form>

```
### Javascript callback function

callback function used by the buttons data-callback attribute.
We get a token from data-callback and we just want to place it in the recaptchaField input field before submitting the form. 

```js
 function onSubmit(token) {
    var form = document.getElementById("contactForm");
    document.getElementById("recaptchaField").value = token;
    form.submit();
}
```
## Server Side

### The model

our enquiry model that with the fields we expect from the form
```c#
public class Enquiry
{
	public string Name { get; set; }
	public string Phone { get; set; }
	public string Email { get; set; }
	public string Message { get; set; }
	public string Recaptcha { get; set; }
}
```

### The controller

In the HomeController we have our contact endpoint. As per the route on the form action attribute

```c#
private static readonly HttpClient _httpclient = new HttpClient();

public async Task<IActionResult> Contact(Enquiry enquiry)
{
	var url = "https://www.google.com/recaptcha/api/siteverify";
	var parameters = new Dictionary<string, string> { { "secret", "private recaptcha key" }, { "response", enquiry.Recaptcha } };
	var encodedContent = new FormUrlEncodedContent(parameters);
	var responseMessage = await _httpclient.PostAsync(url, encodedContent).ConfigureAwait(false);
	if (responseMessage.IsSuccessStatusCode)
	{
		var content = await responseMessage.Content.ReadAsStringAsync();
		var result = JsonConvert.DeserializeObject<Recaptcha>(content);
		if (result.Success)
		{
			// successful recaptcha
		}
	}
}
```
fin
