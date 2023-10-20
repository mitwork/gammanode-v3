package kz.ncanode.configuration;

import kz.gamma.jce.provider.GammaTechProvider;
import kz.gamma.xmldsig.JCPXMLDSigInit;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;

import java.security.Security;

@Slf4j
@Configuration
public class GammaConfiguration {

    @Bean
    @Scope(value = ConfigurableBeanFactory.SCOPE_SINGLETON)
    public GammaTechProvider gammaProvider() {
        log.info("Gamma version: {}", GammaTechProvider.class.getPackage().getImplementationVersion());
        log.info("Tumar version: {}", GammaTechProvider.getTumarCspBuild());
        var gammaProvider = new GammaTechProvider();
        Security.addProvider(gammaProvider);
        JCPXMLDSigInit.init();
        return gammaProvider;
    }

}
