# part zero, the extension method
With extension methods, we can add a method to a object type without modifying the class or creating a sub class
```c#
void Main()
{
	Console.WriteLine("Dog".PrependHello());
}

public static class MyExtensions
{
	public static string PrependHello(this string text)
	{
		return $"Hello {text}";
	}
}
````

whats cool about this is I can make a "fluent api" for strings, what if I made two more extension methods

```c#
public static string AppendWithCat(this string text)
{
	return $"{text}Cat";
}

public static string Name(this string text, string name)
{
	return $"{text} named {name}";
}
```
I could then write something like this

```c#
void Main()
{
	var dogString = "Dog".AppendWithCat()
			     .PrependHello()
			     .Name("Sam");
	
	Console.WriteLine(dogString);
}

```
I find that quite easy to read

# part one, the Enumerable

linq depends on the IEnumerable<T> interface. If I look at linqs select method signature
```c#
public static IEnumerable<TResult> Select<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, TResult> selector);
````
I can see that it is an extension method for the type IEnumerable<TSource>
 

