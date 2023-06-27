using Newtonsoft.Json;
using System.Net.Http.Headers;
using System.Text;

namespace WhatsappNet.Api.Services.WhatsappCloud.SendMessage
{
    public class WhatsappCloudSendMessage : IWhatsappCloudSendMessage
    {
        public async Task<bool> Execute(object model)
        {
            var client = new HttpClient();
            var byteData = Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(model));
            //contiene los datos y asegura que los recursos utilizados por este objeto se liberen automáticamente cuando ya no sean necesarios
            using (var content = new ByteArrayContent(byteData))
            {
                string endpoint = "https://graph.facebook.com";
                string phoneNumberId = "123576210736402";
                string accessToken = "EAASp0vqXUFEBAKSuUFxeRaWa2b4YzwhBoE0oDZBfXetEVEUraVlZBOMI9YH0cZC9olTwT9hdMNtZA9efnoAWNTvhZCJVnxUoWJ6bdWEsVCftaC4vA096NcH6nkZAOYre37fI74v6xW1NJZC28JsN5JPrbZCE3DuVPQ0PbPmGuetSDlsX0uKSinbZC0yRRPiOfc0p5WjFh0bOuD2DuFN30OrXsu19bo65HWSoZD";
                string uri = $"{endpoint}/v17.0/{phoneNumberId}/messages";


                content.Headers.ContentType = new MediaTypeHeaderValue("application/json");
                client.DefaultRequestHeaders.Add("Authorization", $"Bearer {accessToken}");

                var response = await client.PostAsync(uri, content);

                if (response.IsSuccessStatusCode)
                {
                    return true;
                }
                return false;

            }
        }
    }
}
