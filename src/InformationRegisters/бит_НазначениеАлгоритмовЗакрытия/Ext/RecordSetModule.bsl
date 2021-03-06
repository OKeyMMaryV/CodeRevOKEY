#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события "ПередЗаписью".
// 
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
	
		Возврат;
	
	КонецЕсли; 
	
	// Если набор записей не пуст, тогда
    Если Не ЭтотОбъект.Количество() = 0 Тогда
		
		// Проверим заполненность настройки закрытия.
		Для Каждого ТекЗапись Из ЭтотОбъект Цикл
			
			ТекВидЗакрытия		 = ТекЗапись.ВидЗакрытия;
			ТекНастройкаЗакрытия = ТекЗапись.НастройкаЗакрытия;
			
			Если Не ЗначениеЗаполнено(ТекНастройкаЗакрытия) Тогда
				
				ТекстСообщения =  НСтр("ru = 'Для вида закрытия ""%1%"" необходимо указать настройку закрытия!'");
				ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ТекВидЗакрытия);
				бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
				Отказ = Истина;
				
			ИначеЕсли ЗначениеЗаполнено(ТекВидЗакрытия) Тогда
				
				// Проверим правильность выбранного вида и настройки закрытия
				// должны совпадать регистры бухгалтерии.
				Если Не ТекВидЗакрытия.РегистрБухгалтерии = ТекНастройкаЗакрытия.РегистрБухгалтерии Тогда
					
					ТекстСообщения =  НСтр("ru = 'У вида ""%1%"" и настройки ""%2%"" закрытия указаны различные регистры бухгалтерии!'");
					ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ТекВидЗакрытия, ТекНастройкаЗакрытия);
					бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
					Отказ = Истина;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла; // ЭтотОбъект
		
	КонецЕсли;
    
КонецПроцедуры

#КонецОбласти

#КонецЕсли
