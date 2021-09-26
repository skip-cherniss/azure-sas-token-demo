using Azure.Data.Tables;
using System;

namespace sas_token_demo.console
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");

            string stsuri = "https://stvstudiohsldsasdemo.table.core.windows.net/fighterjets?sv=2020-04-08&ss=t&srt=sco&st=2021-09-26T01%3A41%3A01Z&se=2021-09-27T01%3A41%3A01Z&sp=rwdlacu&sig=53sj6qOnEZHUoHf0GDR5dChhVNq52MWeS9cCpaZbOnc%3D";
            TableClient tableClient = new TableClient(new Uri(stsuri));

            string partitionKey = "usa";
            string rowKey = Guid.NewGuid().ToString();

            var entity = new TableEntity(partitionKey, rowKey)
            {
                {"jetname", "F-16" },
                {"pricemil", 40 }
            };

            try
            {
                // Entity doesn't exist in table, so invoking UpsertEntity will simply insert the entity.
                tableClient.UpsertEntity(entity);
            }
            catch (Exception hell)
            {

            }


        }
    }
}
