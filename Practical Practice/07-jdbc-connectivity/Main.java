/*
	Step 1: Goto https://dev.mysql.com/downloads/connector/j/
	Step 2: Select Platform Independent OS and download ZIP file and extract it
	Step 3: Create new Java Project in Eclipse
	Step 4: Project -> Properties -> Java Build Path -> Libraries -> Add External Jar -> Select mysql-connector-j-9.1.0.jar -> Apply -> Apply and Close
	
	-- x -- x -- x
	Step 1: Class.forName('com.mysql.cj.jdbc.Driver')
	Step 2: Connection conn = DriverManager.getConnection(url, username, password)
	Step 3: PreparedStatement stmt = conn.PreparedStatement(query);
	...
	Step 4: stmt.execute() or stmt.executeQuery() or stmt.executeUpdate()
	
*/

import java.sql.*;

public class Main {
	public static void displayUsers(Connection conn) {
		try{
		
			PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users");
			ResultSet rs = stmt.executeQuery();
			
			while(rs.next()) {
				int id = rs.getInt(1);
				String user = rs.getString(2);
				System.out.println("id: " + Integer.toString(id) + " user: " + user);
			}
			
		}
		catch(Exception e) {
			System.out.println(e.getMessage());
		}

		
	}
	
	public static void insertIntoUsersTable(Connection conn) {
		String[] users = {"Tirthraj", "Mulay", "Vartak", "Nags", "Chotu Badmash"};
		
		try {
			String insertQuery = "INSERT INTO users (user) VALUES (?)";
			PreparedStatement stmt = conn.prepareStatement(insertQuery);
			for (int i=0; i<users.length; i++) {
				stmt.setString(1, users[i]);
				stmt.executeUpdate();
			}
			
			System.out.println("Users Inserted into the table");
		}
		catch(Exception e) {
			System.out.println(e.getMessage());
		}
		
	}
	
	public static void createUsersTable(Connection conn) {
		try {
			String createTableQuery = "CREATE TABLE users ("
									+ "id INT PRIMARY KEY AUTO_INCREMENT,"
									+ "user VARCHAR(50) NOT NULL"
									+ ")";
			Statement stmt = conn.createStatement();
			stmt.executeUpdate(createTableQuery);
			System.out.println("Table 'users' created successfully.");
		}
		catch(Exception e) {
			System.out.println(e.getMessage());
		}
	}
	
	public static void updateUserInfo(Connection conn) {
		try {
			String updateQuery = "UPDATE users "
								+ "SET user = ?"
								+ "WHERE id = ?";
			PreparedStatement stmt = conn.prepareStatement(updateQuery);
			stmt.setString(1, "Tirthraj Mahajan");
			stmt.setInt(2, 1);
			stmt.executeUpdate();
			System.out.println("Row Updated Successfully");
		}
		catch(Exception e) {
			System.out.println(e.getMessage());
		}
		
	}
	
	public static void main(String[] args) throws Exception {
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			System.out.println("JDBC Driver Loaded");
		}
		catch(Exception e) {
			System.out.println(e.getMessage());
			return;
		}
		
		String connection_url = "jdbc:mysql://localhost:3306/07_jdbc_connectivity";
		String username = "tirthraj07";
		String password = "tirthraj07";
		Connection conn = DriverManager.getConnection(connection_url,username, password);
		
		createUsersTable(conn);
		insertIntoUsersTable(conn);
		displayUsers(conn);
		updateUserInfo(conn);
		displayUsers(conn);

		conn.close();
		
		/*
		 *	-- OUTPUT --
		 * Table 'users' created successfully.
		 * Users Inserted into the table
		 * id: 1 user: Tirthraj
		 * id: 2 user: Mulay
		 * id: 3 user: Vartak
		 * id: 4 user: Nags
		 * id: 5 user: Chotu Badmash 
		 * Row Updated Successfully
		 * id: 1 user: Tirthraj Mahajan
		 * id: 2 user: Mulay
		 * id: 3 user: Vartak
		 * id: 4 user: Nags
		 * id: 5 user: Chotu Badmash
		 */
		
	}
}

