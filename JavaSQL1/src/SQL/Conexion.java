/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package SQL;

import java.sql.*;


/**
 *
 * @author JA Rodriguez
 */
public class Conexion {
    public static Connection getConexion(){
        String conexionURL = "jdbc:sqlserver://LAPTOP-3A3Q5S9M:1433;"
                + "database=covidHistorico;"
                + "user=sa;"
                + "password=123;"
                + "loginTimeout=30;";
    
        try{
            Connection con = DriverManager.getConnection(conexionURL);
            return con;
        }catch(SQLException ex){
            System.out.println(ex.toString());
            return null; 
        }
    }
}
