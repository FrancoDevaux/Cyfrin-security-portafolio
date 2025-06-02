// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

/*
 * @author not-so-secure-dev
 * @title PasswordStore
 * @notice This contract allows you to store a private password that others won't be able to see. 
 * You can update your password at any time.
 */
contract PasswordStore {
    error PasswordStore__NotOwner();

    // @audit-info s_owner está bien aunque sea private, porque no es un dato sensible (es público de todos modos en la blockchain).
    address private s_owner;
    string private s_password;
    // @audit-issue que la password sea "private", no significa que en realidad sea privada
    // @audit-info Aunque la variable sea private, cualquiera puede leer su valor directamente desde el almacenamiento del contrato
    //(por ejemplo con Etherscan, cast, etc.).

    event SetNetPassword();

    constructor() {
        s_owner = msg.sender;
    }

    /*
     * @notice This function allows only the owner to set a new password.
     * @param newPassword The new password to set.
     */

    // @audit-q can a non-owner set the pass?, Should a non-owner be able to set a pass?
    // @audit-issue (HIGH) any user can set a password ---> "Missing Access Control"
    // solo deberia ser invocado por un rol determinado y cualq puede hacerlo,
    // No valida si el que llama es el owner, entonces no hay ningún filtro
    function setPassword(string memory newPassword) external {
        s_password = newPassword;
        emit SetNetPassword();
    }

    /*
     * @notice This allows only the owner to retrieve the password.
     * @param newPassword The new password to set.
     */
    // @audit-issue parámetro no utilizado por la función, NatSpec se puede eliminar, la linea de arriba
    // no hay un parametro "newPassword"
    function getPassword() external view returns (string memory) {
        if (msg.sender != s_owner) {
            revert PasswordStore__NotOwner();
        }
        return s_password;
    }
}
