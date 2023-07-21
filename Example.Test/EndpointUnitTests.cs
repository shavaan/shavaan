using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.VisualStudio.TestPlatform.TestHost;

namespace Example.Test
{
    public class EndpointUnitTests
    {
        [Fact]
        public async Task TestGreeting()
        {
            await using var application = new WebApplicationFactory<Program>();
            using var client = application.CreateClient();

            var response = await client.GetStringAsync("/greeting?name=Joe%20Tester");

            Assert.Equal("Hello Joe Tester, from a DevSecOps World!", response);
        }
    }
}