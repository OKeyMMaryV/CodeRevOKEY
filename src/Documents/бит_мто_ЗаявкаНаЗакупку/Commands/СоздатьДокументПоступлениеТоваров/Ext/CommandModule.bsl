
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДокументПоступление = СоздатьДокументПоступлениеТоваров(ПараметрКоманды);
	
	Если ДокументПоступление <> Неопределено Тогда
	
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", ДокументПоступление.Ссылка);

		ФормаДокумента = ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.Форма."+ДокументПоступление.ФормаОткрытия, ПараметрыФормы);
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция создает документ поступление товаров и документ бит_мто_ОтражениеФактаЗакупки. 
// 
&НаСервере
Функция СоздатьДокументПоступлениеТоваров(ПараметрКоманды)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_СтатусыОбъектов.Статус,
	               |	бит_СтатусыОбъектов.Объект КАК Заявка
	               |ИЗ
	               |	РегистрСведений.бит_СтатусыОбъектов КАК бит_СтатусыОбъектов
	               |ГДЕ
	               |	бит_СтатусыОбъектов.ВидСтатуса = ЗНАЧЕНИЕ(Перечисление.бит_ВидыСтатусовОбъектов.Статус)
	               |	И бит_СтатусыОбъектов.Объект = &Документ";
	
	Запрос.УстановитьПараметр("Документ", ПараметрКоманды);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Статус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаЗакупку_Утверждена
			ИЛИ Выборка.Статус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаЗакупку_ЧастичноИсполнена Тогда 
			
			ТаблицаОстатков = Документы.бит_мто_ЗаявкаНаЗакупку.ПолучитьОстаткиНоменклатурыПоЗакупке(ПараметрКоманды);
			
			Если НЕ ЗначениеЗаполнено(ТаблицаОстатков) Тогда
				ТекстСообщения =  НСтр("ru = 'Превышен остаток по номенклатуре!'");
				бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
				Возврат Неопределено;
			КонецЕсли; 
			
			ТабличнаяЧастьЗаявки = ПараметрКоманды.Товары.Выгрузить().Скопировать();
			ТабличнаяЧастьЗаявки.Очистить();
			
			Для каждого Строка Из ПараметрКоманды.Товары Цикл
			
				СтрОтбора = Новый Структура();
				СтрОтбора.Вставить("Номенклатура", Строка.Номенклатура);
				СтрОтбора.Вставить("ЗаявкаНаПотребность", Строка.ЗаявкаНаПотребность);
				СтрокиОстатков = ТаблицаОстатков.НайтиСтроки(СтрОтбора);
				
				Если СтрокиОстатков.Количество()>0 
					И СтрокиОстатков[0].Количество > 0 Тогда
				
					НоваяСтрока = ТабличнаяЧастьЗаявки.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
					
					Если Строка.Количество < СтрокиОстатков[0].Количество Тогда
					
						НоваяСтрока.Количество = Строка.Количество;
						
					Иначе	
						НоваяСтрока.Количество = СтрокиОстатков[0].Количество;
					КонецЕсли; 
					
				КонецЕсли; 
			
			КонецЦикла; 
			
			ДокументПоступление = Документы.бит_мто_ЗаявкаНаЗакупку.СоздатьДокументПоступлениеТоваров(ПараметрКоманды, ТабличнаяЧастьЗаявки);
			
			Возврат ДокументПоступление;
			
		ИначеЕсли Выборка.Статус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаЗакупку_Исполнена Тогда	
			
			ТекстСообщения =  НСтр("ru = 'Создание на основании в статусе ""Исполнена"" не выполняется!'");
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
			
		ИначеЕсли Выборка.Статус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаЗакупку_Закрыта Тогда	
			
			ТекстСообщения =  НСтр("ru = 'Создание на основании в статусе ""Закрыта"" не выполняется!'");
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
			
		Иначе	
			ТекстСообщения =  НСтр("ru = 'Создание документа Поступление товаров и услуг разрешено только после утверждения заявки!'");
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		КонецЕсли; 
	
	КонецЦикла;

	Возврат Неопределено;
	
КонецФункции // СоздатьДокументПоступлениеТоваров()

#КонецОбласти


