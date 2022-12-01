/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package proyecto;

import SQL.Conexion;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author JA Rodriguez
 */
public class ConsultaD {
    ResultSet rs;
    private Conexion con = new Conexion();
    private Connection cn = con.getConexion();
    
    public String Consultar(int terr){
        //DefaultTableModel modelo;
        //String [] titulos = {"Producto ID","Territorio","Ventas"};
        //modelo= new DefaultTableModel(null,titulos);
        /*
        System.out.println("hola mundo222");
        try{
            System.out.println("hola mundo");
            CallableStatement csta = cn.prepareCall("{call consulta_d(?)}");
            csta.setInt(1, terr);
            rs=csta.executeQuery();
            System.out.println("valooooor: ");
            System.out.println(rs.getInt(0));
            if(rs.getInt(0)==1){
                return "Si hay clientes uwu";
            }else {
                return "No hay clientes unu";
            }
            
        }catch(Exception e){
            //JOptionPane.showMessageDialog(null, e);
            //return null;
            return "catch";
        }
*/
        return "esto es una prueba";
    }
    public DefaultTableModel Consultar2(int terr){
      
        DefaultTableModel modelo;
        String [] titulos = {"Resultado"};
        String [] Registro = new String[1];
        modelo= new DefaultTableModel(null,titulos);
        try{
            CallableStatement csta= cn.prepareCall("{call consulta_d(?)}");
            csta.setInt(1, terr);
            rs =csta.executeQuery();
            while(rs.next()){
                Registro[0]=rs.getString("Resultado");
                
                modelo.addRow(Registro);
            }
            return modelo;
//
        }catch(Exception e){
                return null;
        }
    }
}
