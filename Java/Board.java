
public class Board {
	final private String name;
	private int height = 10;
	private int width = 10;
	private static int MAX_HEIGHT = 100;
	private static int MAX_WIDTH = 100;
	private int NUM_OF_SQUARES;
	private static int MAX_SQUARES = 200;
	private static int TOTAL_SQUARES;

/* constructor when no paremeters are passed
*/
	public Board(){
		name = "defualt";
		height =10;
		width = 10;
		NUM_OF_SQUARES = 100;
		TOTAL_SQUARES += NUM_OF_SQUARES;
	}

/* second constructor when it is not default
*/
	public Board(int start_height,int start_width,int start_square,String start_name){
		name = start_name;
		setHeight(start_height);
		setWidth(start_width);
		setSquares(start_square);
		
	}
/* set methods to set objects variable values
*/
    public void setHeight(int new_height){
    	if (new_height <= MAX_HEIGHT && new_height >= 0){
	        height = new_height;
    	}
    	else if (new_height < 0){
    		height = 0;
    	}
    	else if (new_height > MAX_HEIGHT){
    		height = MAX_HEIGHT;
    	}
	}
    public void setWidth(int new_width){
    	if (new_width <= MAX_WIDTH && new_width >= 0){
	        width = new_width;
    	}
    	else if (new_width < 0){
    		width = 0;
    	}
    	else if (new_width > MAX_WIDTH){
    		width = MAX_WIDTH;
    	}
	}
    public void setSquares(int new_squares){
    	if (new_squares <= MAX_SQUARES && new_squares >= 0){
    		TOTAL_SQUARES -= NUM_OF_SQUARES;
	        NUM_OF_SQUARES = new_squares;
	        TOTAL_SQUARES += NUM_OF_SQUARES;
    	}
    	else if (new_squares < 0){
    		TOTAL_SQUARES -= NUM_OF_SQUARES;
    		NUM_OF_SQUARES = 0;
    	}
    	else if (new_squares > MAX_SQUARES){
    		TOTAL_SQUARES -= NUM_OF_SQUARES;
    		NUM_OF_SQUARES = MAX_SQUARES;
    		TOTAL_SQUARES += NUM_OF_SQUARES;
    	}
	}
/* get methods which return as strings/ ints
*/
	public String getName(){
		return name;
	}
	public int getHeight(){
		return height;
	}
	public int getWidth(){
		return width;
	}
	public int getSquares(){
		return NUM_OF_SQUARES;
	}
	public static int getMaxHeight(){
		return MAX_HEIGHT;
	}
	public static int getMaxWidth(){
		return MAX_WIDTH;
	}
	public static int getMaxSquares(){
		return MAX_SQUARES;
	}
	public static int getTotal(){
		return TOTAL_SQUARES;
	}
/* returns variables of object in a set sentence structure
*/
	public String toString(){
		return ("The "+ 
	           getName()+ 
	           " has height of "+
	           getHeight()+
	           " , a width of "+
	           getWidth()+
	           " and "+
	           getSquares()+
	           " squares."
	           );
	}
/* calculates and returns area and perimeter
*/
	public int getArea(){
		return (height*width);
	}
	public int getPerimeter(){
		return ((2*height)+(2*width));

	}
}
