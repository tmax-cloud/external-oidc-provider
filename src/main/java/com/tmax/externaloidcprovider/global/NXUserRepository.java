package com.tmax.externaloidcprovider.global;

import com.initech.eam.api.NXUserInfo;

import java.util.HashMap;
import java.util.Map;

public class NXUserRepository {

    private NXUserRepository() {}
    private static final NXUserRepository instance = new NXUserRepository();

    public static NXUserRepository getInstance(){
        return instance;
    }

    private static Map<String, NXUserInfo> userInfos = new HashMap<>();;

    public NXUserInfo getUserInfo(String userId){
        if(!userInfos.containsKey(userId)){
            throw new NullPointerException("No such user in provider repository. May be duplicated user login has been occurred. try again.");
        }
        return userInfos.get(userId);
    }

    public void addUserInfo(String userId, NXUserInfo userInfo){
        userInfos.put(userId, userInfo);
    }

    public void removeUserInfo(String userId){
        if(userInfos.containsKey(userId)){
            userInfos.remove(userId);
        }
    }




}
