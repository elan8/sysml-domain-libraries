namespace Demo;

public interface ICounter
{
    int Read();
    void Add(int amount);
}

public sealed class Counter : ICounter
{
    private int value;

    public int Read() => value;
    public void Add(int amount) => value = checked(value + amount);
}
