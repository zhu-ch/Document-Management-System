package team.abc.ssm.modules.doc.api;

import net.sf.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import team.abc.ssm.modules.author.service.AuthorService;
import team.abc.ssm.modules.doc.service.PaperSearchService;
import team.abc.ssm.modules.organization.service.CommonOrganizeService;

import java.util.List;
import java.util.Map;

/**
 * @author zm
 * @description 文献API
 * @data 2019/5/8
 */
@Controller
@RequestMapping("/doc")
public class DocCountApi {

    @Autowired
    private PaperSearchService paperSearchService;

    @Autowired
    private CommonOrganizeService orgService;

    @Autowired
    private AuthorService authorService;

    @RequestMapping(value = "goDocCount",method = RequestMethod.GET)
    public ModelAndView goDocCount(
            ModelAndView modelAndView
    ){
        modelAndView.setViewName("functions/doc/docCount");

        List<Map<String, String>> paperType = paperSearchService.getPaperType();
        List<String> orgList = orgService.getOrgList();
        List<String> subjectList = authorService.getSubList();

        modelAndView.addObject("paperType", JSONArray.fromObject(paperType));

        modelAndView.addObject("orgList", JSONArray.fromObject(orgList));
        modelAndView.addObject("subjectList", JSONArray.fromObject(subjectList));

        return modelAndView;
    }
}
