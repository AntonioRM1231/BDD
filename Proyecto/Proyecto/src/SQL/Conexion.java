/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package SQL;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author JA Rodriguez
 */
public class Conexion {
    public static Connection getConexion(){
        String conexionURL = "jdbc:sqlserver://192.168.229.6:1433;"
                + "database=AdventureWorks2019_3;"
                + "user=alumno;"
                + "password=Estudiante;"
                + "loginTimeout=30;"
                + "trustservercertificate=true";
    
        try{
            Connection con = DriverManager.getConnection(conexionURL);
            return con;
        }catch(SQLException ex){
            System.out.println(ex.toString());
            return null; 
        }
    }
}
