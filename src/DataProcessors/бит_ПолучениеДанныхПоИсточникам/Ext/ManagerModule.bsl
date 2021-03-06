#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс
	
// Процедура получает данных по источникам данных. 
// 
Функция ПолучитьДанные(ИсточникДанных, СтандартныйПериод, ОтборВОтчете, ТаблицаПараметры, НастройкаПулаПодключений, ДополнительныеПараметры) Экспорт

	ГраницаНач = СтандартныйПериод.ДатаНачала;
	ГраницаКон = Новый Граница(СтандартныйПериод.ДатаОкончания, ВидГраницы.Включая);
	
	ПараметрыЗапроса = бит_МеханизмПолученияДанных.ЗаполнитьСтруктуруПараметровИзТаблицы(ТаблицаПараметры);
	Для каждого КиЗ Из ДополнительныеПараметры Цикл
	
		ПараметрыЗапроса.Вставить(КиЗ.Ключ, КиЗ.Значение);
	
	КонецЦикла; 
	
	Если ТипЗнч(ИсточникДанных) = Тип("СправочникСсылка.бит_ИсточникиДанных") Тогда
		
		// Получим таблицу с данными по источнику данных.
		СтрПар = бит_МеханизмПолученияДанных.КонструкторПараметры_ПолучитьДанныеПоИсточнику();
		СтрПар.НастройкаПулаПодключений = НастройкаПулаПодключений;
		СтрПар.Параметры                = ПараметрыЗапроса;
		СтрПар.ОтборВОтчете             = ОтборВОтчете;
		
		ТаблицаРезультат = бит_МеханизмПолученияДанных.ПолучитьДанныеПоИсточнику(ИсточникДанных
																				,ГраницаНач
																				,ГраницаКон
																				,СтрПар);
	Иначе
		
		ПоказыватьИндикатор = НЕ бит_УправлениеПользователямиСервер.ПолучитьЗначениеПоУмолчанию("НеОтображатьИндикаторКомпоновкиИсточников");
		// Получим таблицу с данными по способу компоновки источников данных.
        СтрПар = бит_МеханизмПолученияДанных.КонструкторПараметры_ПолучитьДанныеПоСпособуКомпоновки();
		СтрПар.НастройкаПулаПодключений = НастройкаПулаПодключений;
		СтрПар.Параметры                = ПараметрыЗапроса;		
		СтрПар.ОтборВОтчете             = ОтборВОтчете;
		СтрПар.ПоказыватьИндикатор      = ПоказыватьИндикатор;
		
		ТаблицаРезультат = бит_МеханизмПолученияДанных.ПолучитьДанныеПоИсточникам(ИсточникДанных
																				 ,ГраницаНач
																				 ,ГраницаКон
																				 ,СтрПар);
																			
		бит_МеханизмПолученияДанных.ДополнитьРезультатИВыполнитьРасчет(ИсточникДанных, ТаблицаРезультат);
		
	КонецЕсли;
	
	Возврат ТаблицаРезультат;
	
КонецФункции // ПолучитьДанные()
	
#КонецОбласти
 
#КонецЕсли
