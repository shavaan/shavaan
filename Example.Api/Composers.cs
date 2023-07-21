class Composers
{
    IList<string> genres;

    public Composers()    {
      
        genres = new List<string> { "Classical", "Romantic", "Jazz" };
    }

    public IList<string> Names
    {
        get { return genres; }
    }

    public IList<string> Genres
    {
        get { return genres; }
    }
}