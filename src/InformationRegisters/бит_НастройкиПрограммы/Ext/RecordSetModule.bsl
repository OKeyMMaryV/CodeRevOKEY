#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если Не Отказ Тогда	
        
        бит_ОбщиеПеременныеСервер.ЗначениеПеременнойУстановить("бит_НастройкиПрограммы"
                                                            , бит_ОбщегоНазначения.ЗаполнениеНастроекПрограммы()
                                                            , ИСТИНА);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
