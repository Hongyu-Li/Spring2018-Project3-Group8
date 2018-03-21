def labelResponse(img_train_dir, label_csv):
    response = np.float32([])
    for file_name in os.listdir(img_train_dir):
        s1 = re.findall("\d+",file_name)[0]
        for i in range(3000):
            s2 = re.findall("\d+",label_csv.img[i])[0]
            if s1 == s2:
                response = np.append(response, label_csv.label[i])
                break
    return(response)
