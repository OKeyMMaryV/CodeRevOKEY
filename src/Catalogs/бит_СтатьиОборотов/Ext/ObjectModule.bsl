#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем мНастройкиПрограммы Экспорт; // Хранит настройки БИТ.
Перем мФильтроватьСтатьиОборотовПоПринадлежности Экспорт; // Хранит значение настройки программы "ФильтроватьСтатьиОборотовПоПринадлежности".
Перем мНастройкиИзмерений Экспорт; // Хранит настройки используемых дополнительных измерений.

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоНовый() Тогда
		
		РегистрыСведений.бит_МаскиКодов.ЗаполнитьКодификаторДляЭлементаСправочника(ДанныеЗаполнения, Ссылка, Кодификатор);
		
		Если Не ЭтоГруппа Тогда
			
			Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
				ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);			
			КонецЕсли; 
			
			Если НЕ ЗначениеЗаполнено(ТипСтатьи) Тогда
				ТипСтатьи  = Перечисления.бит_ТипыСтатейОборотов.БДДС;
			КонецЕсли; 
			
			Если НЕ ЗначениеЗаполнено(СтавкаНДС) Тогда
				СтавкаНДС = бит_УправлениеПользователямиСервер.ЗначениеПоУмолчаниюТиповой("ОсновнаяСтавкаНДС");  					
			КонецЕсли; 
			Учет_Сумма = Истина;
			
			МетаОбъект = Метаданные();
			
			// заполнение по умолчанию типов составных аналитик
			НастройкиИзмерений = бит_МеханизмДопИзмерений.ПолучитьНастройкиДополнительныхИзмерений();
			
			Для каждого КиЗ Из НастройкиИзмерений Цикл
				
				ИмяИзмерения = КиЗ.Ключ;
				ТекНастройка = КиЗ.Значение;
				Если ТекНастройка.ЭтоСоставнойТип Тогда
				
					 ИмяРеквизита = "ИмяТипаПоУмолчанию_"+ИмяИзмерения;
					 Если бит_РаботаСМетаданными.ЕстьРеквизит(ИмяРеквизита, МетаОбъект) Тогда
					 	  ЭтотОбъект[ИмяРеквизита] = ТекНастройка.ИмяТипаПоУмолчанию;
					 КонецЕсли; 
				КонецЕсли; 
			КонецЦикла; 
		КонецЕсли;
	КонецЕсли; 

КонецПроцедуры // ОбработкаЗаполнения()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ТипСтатьи = Перечисления.бит_ТипыСтатейОборотов.НефинансовыйПоказатель 
		 ИЛИ ТипСтатьи = Перечисления.бит_ТипыСтатейОборотов.ФинансовыйПоказатель Тогда
		
		бит_РаботаСКоллекциямиКлиентСервер.УдалитьЭлементМассиваПоЗначению(ПроверяемыеРеквизиты, "РасходДоход");	
		
	Иначе
		
		ПроверяемыеРеквизиты.Добавить("РасходДоход");		
		
	КонецЕсли; 
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 	
	
	бит_ук_СлужебныйСервер.РегистрацияНачалоСобытия(Отказ, ДополнительныеСвойства);
	
	// Выполним синхронизацию пометки на удаление объекта и дополнительных файлов.
	бит_ХранениеДополнительнойИнформации.СинхронизацияПометкиНаУдалениеУДополнительныхФайлов(ЭтотОбъект);
	
	Если Не ЭтоНовый() И Не ПометкаУдаления=Ссылка.ПометкаУдаления Тогда
		// В случае установки или снятия пометки удаления не производить проверку.
		Возврат;
	КонецЕсли;
	
	// Очистка кодификатора, если в нем нет значимых символов.
	КодификаторЧистый = СокрЛП(бит_БухгалтерияКлиентСервер.УдалитьРазделителиИзСтроки(Кодификатор));
	Если ПустаяСтрока(КодификаторЧистый) Тогда
		Кодификатор = "";	
	КонецЕсли;
	
	МетаСпр = Метаданные.Справочники.бит_СтатьиОборотов;
	
	// Выполним проверку заполнения элемента справочника.
	Если НЕ ЭтоГруппа Тогда
		
		Заголовок = Нстр("ru = 'Проверка заполнения элемента справочника """"Статьи оборотов""'"); 
		
		// Укажем, что надо проверить:
		СтруктураРеквизитов = Новый Структура;
		СтруктураРеквизитов.Вставить("СтавкаНДС",Нстр("ru = 'Ставка НДС'"));		
		
		СтруктураРеквизитов.Вставить("ТипСтатьи", Нстр("ru = 'Тип статьи'"));
		Если ТипСтатьи <> Перечисления.бит_ТипыСтатейОборотов.НефинансовыйПоказатель 
			 И ТипСтатьи <> Перечисления.бит_ТипыСтатейОборотов.ФинансовыйПоказатель Тогда
			 
			СтруктураРеквизитов.Вставить("РасходДоход",Нстр("ru = 'Направление'"));
			
		КонецЕсли;
		
		Если Учет_Количество И бит_ОбщегоНазначения.ЕстьРеквизит("ЕдиницаИзмерения", МетаСпр) Тогда
		 	Если НЕ бит_ОбщегоНазначения.ЭтоПримитивныйТип(ЭтотОбъект["ЕдиницаИзмерения"]) Тогда
		    	СтруктураРеквизитов.Вставить("ЕдиницаИзмерения", Нстр("ru = 'Единица измерения'"));
			КонецЕсли;		
		КонецЕсли;
		
		// Вызовем общую процедуру проверки.
		бит_РаботаСМетаданными.ПроверитьЗаполнениеШапки(ЭтотОбъект, СтруктураРеквизитов, Отказ, Заголовок);
		
		// Должен быть указан ввод хотя бы одного показателя.
		Если НЕ Учет_Количество И НЕ Учет_Сумма Тогда
			ТекстСообщения = Нстр("ru = 'Не указан ввод НИ количества НИ суммы. Следует указать ввод хотя бы одного показателя.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , ,Отказ); 
		КонецЕсли; 
		
		// Проверяем, если есть движения по статье в регистре бит_ОборотыПоБюджетам 
		// и изменены ключевые реквизиты, то выводим сообщение об ошибке и запрещаем сохранение изменений.
		
		СтруктураРеквизитов = Новый Структура;
		СтруктураРеквизитов.Вставить("Учет_Количество");
		СтруктураРеквизитов.Вставить("Учет_Сумма");
		МетаОбъект = ЭтотОбъект.Метаданные();
		Если бит_ОбщегоНазначения.ЕстьРеквизит("Учет_Контрагент", МетаОбъект) Тогда
			СтруктураРеквизитов.Вставить("Учет_Контрагент");
		КонецЕсли;
		Если бит_ОбщегоНазначения.ЕстьРеквизит("Учет_ДоговорКонтрагента", МетаОбъект) Тогда
			СтруктураРеквизитов.Вставить("Учет_ДоговорКонтрагента");
		КонецЕсли;
		Если бит_ОбщегоНазначения.ЕстьРеквизит("Учет_Проект", МетаОбъект) Тогда
			СтруктураРеквизитов.Вставить("Учет_Проект");
		КонецЕсли;
		Если бит_ОбщегоНазначения.ЕстьРеквизит("Учет_НоменклатурнаяГруппа", МетаОбъект) Тогда
			СтруктураРеквизитов.Вставить("Учет_НоменклатурнаяГруппа");
		КонецЕсли;
		Если бит_ОбщегоНазначения.ЕстьРеквизит("Учет_БанковскийСчет", МетаОбъект) Тогда
			СтруктураРеквизитов.Вставить("Учет_БанковскийСчет");
		КонецЕсли;		
		
		Если НЕ ЭтоНовый() 
			И ЕстьДвиженияПоСтатье() Тогда
			
			ИзмененныеРеквизиты = бит_ОбщегоНазначения.ПолучитьСтруктуруИзмененныхРеквизитовОбъекта(ЭтотОбъект, СтруктураРеквизитов, Истина);
			Если НЕ ИзмененныеРеквизиты = Неопределено Тогда
				
				// Укажем реквизиты изменение которых всегда запрещено при наличии движений по статье.
				МассивИсключений = Новый Массив;
				Если Ссылка.Учет_Количество = Истина И ЭтотОбъект.Учет_Количество = Ложь Тогда
					// Ставить флажок разрешаем - снимать нет
					МассивИсключений.Добавить("Учет_Количество");
				КонецЕсли;
				Если Ссылка.Учет_Сумма = Истина И ЭтотОбъект.Учет_Сумма = Ложь Тогда
					// Ставить флажок разрешаем - снимать нет					
				    МассивИсключений.Добавить("Учет_Сумма");
				КонецЕсли;
				
				ОтказатьВСохранении = Ложь;
				
				Для Каждого ИмяРеквизита Из ИзмененныеРеквизиты Цикл
					
					НайденноеИсключение = МассивИсключений.Найти(ИмяРеквизита.Ключ);
					Если НЕ НайденноеИсключение = Неопределено Тогда
						ОтказатьВСохранении = Истина;
						Прервать;
					КонецЕсли;
					
					// Часть разрезов бюджетирования разрешено добавлять при наличии движений.
					Если НЕ ЭтотОбъект[ИмяРеквизита.Ключ] Тогда
						ОтказатьВСохранении = Истина;
						Прервать;
					КонецЕсли;
					
				КонецЦикла;
				
				Если ОтказатьВСохранении Тогда
					
					ТекстСообщения = НСтр("ru='Сохранение изменений невозможно, так как по данной статье есть движения в
					| регистре ""Обороты по бюджетам"" и были изменены вышеперечисленные реквизиты.'");
					бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения,,,Отказ);
					
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		// Проверим заполнение табличной части Шаблоны проводок.
		ПроверитьЗаполнениеШаблоновПроводок(ШаблоныПроводок,Нстр("ru = 'Шаблоны проводок'"),Отказ,Заголовок,СтатусСообщения);
		
	КонецЕсли; // НЕ ЭтоГруппа 
		
		
КонецПроцедуры // ПередЗаписью()

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 	
	
	бит_ук_СлужебныйСервер.РегистрацияПриЗаписи(Отказ, ЭтотОбъект.ДополнительныеСвойства, Метаданные().ПолноеИмя());
	
	Если НЕ Отказ Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Кодификатор = "";
	
	Если ЗначениеЗаполнено(ОбъектКопирования.Родитель) Тогда
		ДанныеЗаполнения = Новый Структура;
		ДанныеЗаполнения.Вставить("Родитель", ОбъектКопирования.Родитель);
	Иначе
		ДанныеЗаполнения = Неопределено;
	КонецЕсли;
	
	РегистрыСведений.бит_МаскиКодов.ЗаполнитьКодификаторДляЭлементаСправочника(ДанныеЗаполнения, Ссылка, Кодификатор);
	
КонецПроцедуры // ПриКопировании()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура проверяет заполнение табличной части ШаблоныПроводок.
// 
// Параметры:
//  ШаблоныПроводок  - ТабличнаяЧасть.
//  ИмяТаблицы       - Строка.
//  Отказ            - Булево.
//  Заловок          - Строка.
//  СтатусСообщения  - СтатусСообщения.
// 
Процедура ПроверитьЗаполнениеШаблоновПроводок(ТаблицаДляПроверки, ИмяТаблицы, Отказ, Заголовок, СтатусСообщения)

	Для каждого СтрокаТаблицы Из ТаблицаДляПроверки Цикл
        
        СвСчДт = бит_БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТаблицы.СчетДТ);
        СвСчКт = бит_БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТаблицы.СчетКТ);
        
		Если ЗначениеЗаполнено(СтрокаТаблицы.СчетДТ) 
			 И ЗначениеЗаполнено(СтрокаТаблицы.СчетКТ) 
			 И (СвСчДт.Забалансовый <> СвСчКт.Забалансовый)  Тогда
			 
			БалансовыйСчет   = ?(СвСчДТ.Забалансовый, СтрокаТаблицы.СчетКТ, СтрокаТаблицы.СчетДТ);
			ЗабалансовыйСчет = ?(СвСчДТ.Забалансовый, СтрокаТаблицы.СчетДТ, СтрокаТаблицы.СчетКТ);
			
			ТекстСообщения = СтрШаблон(Нстр("ru = 'Строке № %1 табличной части ""%2"". "
						   + "Балансовый счет ""%3"" не может корреспондировать с забалансовым ""%4"".'"),
						   СтрокаТаблицы.НомерСтроки, ИмяТаблицы, БалансовыйСчет, ЗабалансовыйСчет);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , ,Отказ); 			   
		КонецЕсли; 
		
		Если (ЗначениеЗаполнено(СтрокаТаблицы.СчетДТ) 
			 И НЕ ЗначениеЗаполнено(СтрокаТаблицы.СчетКТ) 
			 И НЕ СвСчДТ.Забалансовый)
			 ИЛИ (ЗначениеЗаполнено(СтрокаТаблицы.СчетКТ) 
				  И НЕ ЗначениеЗаполнено(СтрокаТаблицы.СчетДТ) 
				  И НЕ СвСчКТ.Забалансовый) Тогда
				  
			БалансовыйСчет  = ?(ЗначениеЗаполнено(СтрокаТаблицы.СчетДТ), СтрокаТаблицы.СчетДТ, СтрокаТаблицы.СчетКТ);
				  
			ТекстСообщения = СтрШаблон(Нстр("ru = 'Строке № %1 табличной части ""%2"". "
						   + "Балансовый счет ""%3"" не может корреспондировать с пустым.'"),
						   СтрокаТаблицы.НомерСтроки, ИмяТаблицы, БалансовыйСчет);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , ,Отказ); 
		КонецЕсли; 
	КонецЦикла; 

КонецПроцедуры

Функция ЕстьДвиженияПоСтатье()

	// Выясняем, есть ли движения по статье в регистре бит_ОборотыПоБюджетам.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СтатьяОборотов", Ссылка);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	               |	бит_ОборотыПоБюджетам.СтатьяОборотов
	               |ИЗ
	               |	РегистрНакопления.бит_ОборотыПоБюджетам КАК бит_ОборотыПоБюджетам
	               |ГДЕ
	               |	бит_ОборотыПоБюджетам.СтатьяОборотов = &СтатьяОборотов";
				   
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		 ЕстьДвижения = Ложь;
	 Иначе
		 ЕстьДвижения = Истина;
	КонецЕсли; 
	
    Возврат ЕстьДвижения;
	
КонецФункции

#КонецОбласти

#КонецЕсли
