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
We can use an array or queue etc with these extension methods as they implement IEnumerable, but to get a feel for how they work with linq let define our own type.
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

public void Main()
{
	foreach (var number in new Numerable())
	{
		Console.WriteLine(number);
	}
}

````
Maybe you should not run that run method though...

When you read this implementation it makes it easy to see how the control flow works and gives it that coroutine behaviour. 

Its a lot of boilerplate though so you can write it like this. 

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

Even though it is an infinite loop this can still be useful to us due to the afformentioned coroutine behaviour. 
Let write an extension method that only grabs a certain amount of these random number.

```c#
public static class MyExtensions
{
	public static IEnumerable Grab(this IEnumerable enumerable, int amountToGrab)
	{
		var enumerator = enumerable.GetEnumerator();
		for (int i = 0; i < amountToGrab; i++)
		{
			if(enumerator.MoveNext())
				yield return enumerator.Current;
		}
	}
}
```

finally we can write a main method that is safe to run

```c#
void Main()
{
	var n = NumberableWithYield().Grab(5);
	foreach (var number in n)
	{
		Console.WriteLine(number);
	}
}
````

