# part zero, the extension method
With extension methods, we can add a method to a object type without modifying the class or creating a sub class
```c#
void Main()
{
	Console.WriteLine("Dog".AddHello());
}

public static class MyExtensions
{
	public static string AddHello(this string text)
	{
		return $"Hello {text}";
	}
}
````
# part one, the Enumerable

linq depends on the IEnumerable<T> interface. If I look at linqs select method signature
{% highlight c# %}
public static IEnumerable<TResult> Select<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, TResult> selector);
{% endhighlight %}
I can see that it is an extension method for the type IEnumerable<TSource>
 
