# and here you have it, the worlds most complete ioc container

```c#
interface ISecondService
{
	public string Get();
}

class SecondService : ISecondService
{
	public string Get()
	{
		return "Second Service";
	}
}

interface IMyService
{
	public string Get();
}

class MyServiceOne : IMyService
{
	private ISecondService _secondService;
	
	public MyServiceOne(ISecondService secondService)
	{
		_secondService = secondService;
	}
	
	public string Get()
	{
		return "MyServiceOne "+ _secondService.Get();
	}
}

interface ICore
{
	void Run();
}

class Core : ICore
{
	private IMyService _myService;
	
	public Core(IMyService myService)
	{
		_myService = myService;
	}
	
	public void Run()
	{
		Console.WriteLine(_myService.Get());
	}
}

class Benject
{
	private Dictionary<Type, Type> _kernal = new Dictionary<Type, Type>();
	
	public void Bind<TInterface, TImplementation>() where TImplementation : TInterface
	{
		_kernal.Add(typeof(TInterface), typeof(TImplementation));
	}

	public object Inject(Type t)
	{
		if (!_kernal.TryGetValue(t, out Type implementation))
			throw new Exception("This type is not bound");

		var constructors = implementation.GetConstructors();
		
		if (constructors.Length != 1)
			throw new Exception("Types Should Have One Constructor");
		
		var constructor = constructors.First();
		var parameters =
			constructor
			.GetParameters()
			.Select(parameterInfo => Inject(parameterInfo.ParameterType))
			.ToArray();

		return constructor.Invoke(parameters);
	}
	
	public T Initialize<T>()
	{
		return (T)Inject(typeof(T));
	}
}

class Program
{
	static void Main(string[] args)
	{
		Benject benject = new Benject();
		benject.Bind<ICore, Core>();
		benject.Bind<IMyService, MyServiceOne>();
		benject.Bind<ISecondService, SecondService>();
		var core = benject.Initialize<ICore>();
		core.Run();
	}
}
 ```
