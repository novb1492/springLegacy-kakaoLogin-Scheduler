package com.ex.co;

import java.io.File;
import java.io.FileNotFoundException;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

import com.amazonaws.ClientConfiguration;
import com.amazonaws.Protocol;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.PutObjectRequest;

@Component
public class awsConfig {

    private String accessKey ="AKIAXVQHL24PHXPXKYU4";
    private String secretKey ="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";

    private AmazonS3 s3Client;

    public awsConfig () {
        AWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);
        ClientConfiguration clientConfig = new ClientConfiguration();
        clientConfig.setProtocol(Protocol.HTTP);
        this.s3Client = new AmazonS3Client(credentials, clientConfig);
        s3Client.setEndpoint("s3.ap-northeast-2.amazonaws.com"); //  아시아 태평양 서울
    }


    public void fileupload(String bucketName,String fileName, File file) throws FileNotFoundException{

        String fileExt = file.getName().split("[.]")[1];
        this.s3Client.putObject(new PutObjectRequest(bucketName, "bucket하위 경로/"+fileName+"."+fileExt, file)
                .withCannedAcl(CannedAccessControlList.PublicRead));
    }
}

