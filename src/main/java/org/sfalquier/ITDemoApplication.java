package org.sfalquier;

import io.dropwizard.Application;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;
import org.sfalquier.health.TemplateHealthCheck;
import org.sfalquier.resources.ITDemoResource;

public class ITDemoApplication extends Application<ITDemoConfiguration> {
    public static void main(String[] args) throws Exception {
        new ITDemoApplication().run(args);
    }

    @Override
    public String getName() {
        return "hello-world";
    }

    @Override
    public void initialize(Bootstrap<ITDemoConfiguration> bootstrap) {
        // nothing to do yet
    }

    @Override
    public void run(ITDemoConfiguration configuration,
                    Environment environment) {
        final ITDemoResource resource = new ITDemoResource(
                configuration.getTemplate(),
                configuration.getDefaultName()
        );
        environment.jersey().register(resource);

        final TemplateHealthCheck healthCheck =
                new TemplateHealthCheck(configuration.getTemplate());
        environment.healthChecks().register("template", healthCheck);
    }

}
