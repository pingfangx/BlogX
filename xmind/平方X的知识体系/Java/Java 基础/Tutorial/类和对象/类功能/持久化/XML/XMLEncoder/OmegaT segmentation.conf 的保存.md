使用的 XMLEncoder

    org.omegat.core.data.RealProject#saveProjectProperties
        SRX.saveTo(config.getProjectSRX(), new File(config.getProjectInternal(), SRX.CONF_SENTSEG));
    org.omegat.core.segmentation.SRX#saveTo
    
    public static void saveTo(SRX srx, File outFile) throws IOException {
        if (srx == null) {
            outFile.delete();
            return;
        }
        try {
            srx.setVersion(CURRENT_VERSION);
            XMLEncoder xmlenc = new XMLEncoder(new FileOutputStream(outFile));
            xmlenc.writeObject(srx);
            xmlenc.close();
        } catch (IOException ioe) {
            Log.logErrorRB("CORE_SRX_ERROR_SAVING_SEGMENTATION_CONFIG");
            Log.log(ioe);
            throw ioe;
        }
    }
