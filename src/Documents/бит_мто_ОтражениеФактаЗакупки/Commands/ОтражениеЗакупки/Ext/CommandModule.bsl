
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДокументОтражение = бит_мто.НайтиДокументОтражения(ПараметрКоманды);
	
	Если ЗначениеЗаполнено(ДокументОтражение) Тогда
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Ключ", ДокументОтражение);
		Попытка
			
			ОткрытьФорму("Документ.бит_мто_ОтражениеФактаЗакупки.ФормаОбъекта"
			               , ПараметрыФормы
						   , ПараметрыВыполненияКоманды.Источник
						   , ПараметрыВыполненияКоманды.Уникальность
						   , ПараметрыВыполненияКоманды.Окно);
		Исключение
						   
			ТекстСообщения =  НСтр("ru = 'Нет прав доступа к ""Отражению факта закупки"" для текущего документа.'");
			
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
			
		КонецПопытки;

					   
	Иначе				   
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ДокументОснование", ПараметрКоманды);
		ОткрытьФорму("Документ.бит_мто_ОтражениеФактаЗакупки.Форма.ФормаНетДокументОтражения"
		               , ПараметрыФормы
					   , ПараметрыВыполненияКоманды.Источник
					   , ПараметрыВыполненияКоманды.Уникальность
					   , ПараметрыВыполненияКоманды.Окно);
		
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
