
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	НаборОбъект = Справочники.НаборыДополнительныхРеквизитовИСведений.Документ_ПутевойЛист.ПолучитьОбъект();
	НаборОбъект.Используется = Значение;
	НаборОбъект.Записать();
	
	Если Значение Тогда
		
		// Обеспечим начальные данные: статья затрат, вид номенклатуры, единица измерения
		КлассификаторыДоходовРасходов.ОбеспечитьФункциональность(Справочники.СтатьиЗатрат, "ВедетсяУчетПоПутевымЛистам");
		Справочники.ВидыНоменклатуры.НайтиСоздатьЭлементТопливо(); // Вид номенклатуры - Топливо
		Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("112"); // Литры
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли