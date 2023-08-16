




class Api{

  static const baseUrl = 'https://shop-backs-wg4i.onrender.com';

  /// auth api
  static const userLogin = '$baseUrl/api/userLogin';
  static const userSignUp = '$baseUrl/api/userSignUp';
  static const userUpdate = '$baseUrl/api/userUpdate';

  /// product api
  static const addProduct = '$baseUrl/api/add/product';
  static const productUpdate = '$baseUrl/api/update/product';
  static const productRemove = '$baseUrl/api/remove/product';

  /// order api
   static const orderAdd = '$baseUrl/api/orderAdd';
    static const getOrderByUser = '$baseUrl/api/getUserOrder';


}