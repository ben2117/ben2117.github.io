# and here you have it, the worlds most complete ioc container

```c#
interface IMyService
{
	public string Get();
}

class MyServiceOne : IMyService
{
	public string Get()
	{
		return "MyServiceOne";
	}
}

class MyServiceTwo : IMyService
{
	private string _name;
	public MyServiceTwo(string name)
	{
		_name = name;
	}
	public string Get()
	{
		return _name;
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
	private Dictionary<Type, Func<object>> _kernal = new Dictionary<Type, Func<object>>();
	public void Bind<TInterface, TImplementation>() where TImplementation : TInterface
	{
		_kernal.Add(typeof(TInterface), () => {
			var type = typeof(TImplementation);
			var constructors = type.GetConstructors();
			if (constructors.Length > 1)
				throw new Exception();
			var constructor = constructors[0];
			var parameters = new List<object>();
			foreach (var parameterInfo in constructor.GetParameters())
			{
				if (_kernal.TryGetValue(parameterInfo.ParameterType, out Func<object> result))
					parameters.Add(result());
				else throw new Exception();
			}
			return constructor.Invoke(parameters.ToArray());
		});
	}

	public TKey Resolve<TKey>()
	{
		if (_kernal.TryGetValue(typeof(TKey), out Func<object> result))
			return (TKey)result();
		else throw new Exception();
	}

}
class Program
{
	static void Main(string[] args)
	{
		Benject benject = new Benject();
		benject.Bind<ICore, Core>();
		benject.Bind<IMyService, MyServiceOne>();
		var core = benject.Resolve<ICore>();
		core.Run();
	}
}
 ```
