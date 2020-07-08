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
 
For a contrived example:

````c#
public class Numberator : IEnumerator
{
	public Numberator()
	{
		_random = new Random();
		_currentNumber = 0;
	}

	private Random _random;
	int _currentNumber;
	public object Current => _currentNumber;

	public bool MoveNext()
	{
		_currentNumber = _random.Next();
		return true;
	}

	public void Reset()
	{
		_currentNumber = 0;
	}
}

public class Numerable : IEnumerable
{
	public IEnumerator GetEnumerator()
	{
		return new Numberator();
	}
}

public void Run()
{
	foreach (var number in new Numerable())
	{
		Console.WriteLine(number);
	}
}

````
Maybe you should not run that run method though...

that is a lot of code though, perhaps someone thought of a way to make this easier well yes, I can do the same thing with yield

```c#
private Random _random = new Random();
public IEnumerable NumberableWithYield()
{
	while (true)
	{
		yield return _random.Next();
	}
}
```

I think once you see these one after the other it gives you an understanding of how coroutines work and how things can be lazily evaluated.

