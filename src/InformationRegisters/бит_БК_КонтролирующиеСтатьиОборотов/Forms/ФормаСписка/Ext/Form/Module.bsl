

&НаКлиенте
Процедура РегистрСведенийСписокПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока = Истина Тогда 
		 Элементы.РегистрСведенийСписок.ТекущиеДанные.АктивностьСтроки = Истина;
		
	КонецЕсли;
	
	Если НЕ НоваяСтрока Тогда
		
		Предупреждение("Изменение данных может привести к некорректной работе документов бюджетного контроля.");
		
	КонецЕсли;
	
КонецПроцедуры
