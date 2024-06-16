using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DryCleaning
{
    public class SQL
    {
        private string connectionString = @"Data Source=сервер;Initial Catalog=названиеБД; Integrated Security=True";

        public T ExecuteScalar<T>(string query)
        {
            using (var connection = new SqlConnection(connectionString))
            {
                using (var command = new SqlCommand(query, connection))
                {
                    connection.Open();
                    return (T)command.ExecuteScalar();
                }
            }
        }


        public void ExecuteNonQuery(string query)
        {
            using (var connection = new SqlConnection(connectionString))
            {
                using (var command = new SqlCommand(query, connection))
                {
                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }

        public SqlDataReader ExecuteReader(string query)
        {
            var connection = new SqlConnection(connectionString);
            using (var command = new SqlCommand(query, connection))
            {
                connection.Open();
                return command.ExecuteReader(CommandBehavior.CloseConnection);
            }
        }

        public class QueryResult
        {
            public DataTable DataTable { get; set; }
            public SqlDataAdapter SqlDataAdapter { get; set; }
            public SqlCommand Command { get; set; }
        }
        /// <summary>
        /// Запрос в базу данных для вывода в таблицу
        /// </summary>
        /// <param name="query"></param>
        /// <returns></returns>
        public QueryResult ExecuteQuery(string query)
        {
            using (var connection = new SqlConnection(connectionString))
            {

                using (var command = new SqlCommand(query, connection))
                {

                    using (var adapter = new SqlDataAdapter(command))
                    {
                        var dataTable = new DataTable();
                        adapter.Fill(dataTable);
                        return new QueryResult
                        {
                            DataTable = dataTable,
                            SqlDataAdapter = adapter,
                            Command = command
                        };
                    }
                }
            }
        }

        /// <summary>
        /// Обновление данных в БД
        /// </summary>
        /// <param name="adapter"></param>
        /// <param name="dataTable"></param>
        /// 
        public void UpdateData(SqlDataAdapter adapter, DataTable dataTable, SqlCommand command)
        {
            using (var builder = new SqlCommandBuilder(adapter))
            {
                // Устанавливаем команду выборки
                command.Connection = getConnection();
                adapter.SelectCommand = command;
                adapter.Update(dataTable);
            }
        }


        public SqlConnection getConnection()
        {
            return new SqlConnection(connectionString);
        }


    }
}


========================================

инициализация компонентов 

 SQL sql = new SQL();
 DataTable datatable;
 SqlCommand command;
 SqlDataAdapter adapter;

вывод из таблицы

 var result = sql.ExecuteQuery($"SELECT * from Branches");
 datatable = result.DataTable;
 command = result.Command;
 adapter = result.SqlDataAdapter;
 dataGridViewBranches.DataSource = datatable;

yes/no messagebox

 MessageBoxButtons msb = MessageBoxButtons.YesNo;
 String message = "Вы действительно хотите выйти?";
 String caption = "Выход";
 if (MessageBox.Show(message, caption, msb) == DialogResult.Yes)
     this.Close();