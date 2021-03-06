#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем мВалютаМеждУчета Экспорт; // Хранит валюту международного учета

Перем мКоличествоСубконтоМУ Экспорт; // Хранит количество субконто международного учета в документа.

Перем мВидыКлассовВидыОпераций Экспорт; // Хранит соответствие классов и видов операций.

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	

	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = бит_ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// Проверка ручной корректировки
	Если бит_ОбщегоНазначения.РучнаяКорректировкаОбработкаПроведения(РучнаяКорректировка,Отказ,Заголовок,ЭтотОбъект, Ложь) Тогда
		Возврат
	КонецЕсли;
	
	СтруктураШапкиДокумента = бит_ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	СтруктураКурсыВалют = СформироватьСтруктуруКурсовВалют(СтруктураШапкиДокумента,Отказ,Заголовок);
	
	// Получим исторические курсы валют по каждому НМА.
	МассивОС = ОсновныеСредства.ВыгрузитьКолонку("ОсновноеСредство");
	МассивОС = бит_РаботаСКоллекциями.УдалитьПовторяющиесяЭлементыМассива(МассивОС);
	ИсторическиеКурсы = ПолучитьСтруктуруИсторическихКурсов(СтруктураШапкиДокумента, МассивОС, СтруктураШапкиДокумента.Дата, СтруктураКурсыВалют);

	СтруктураТаблиц = Документы.бит_му_ОбесценениеОС.ПодготовитьТаблицыДокумента(ЭтотОбъект, СтруктураШапкиДокумента);
	
	ПроверитьТаблицыДокумента(СтруктураШапкиДокумента,СтруктураТаблиц,Отказ,Заголовок);
	
	Если НЕ Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента,СтруктураТаблиц,СтруктураКурсыВалют,ИсторическиеКурсы,Отказ,Заголовок);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	бит_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
 
	
	// Выполним синхронизацию пометки на удаление объекта и дополнительных файлов.
	бит_ХранениеДополнительнойИнформации.СинхронизацияПометкиНаУдалениеУДополнительныхФайлов(ЭтотОбъект);
	
КонецПроцедуры // ПередЗаписью()
	
Процедура ПриЗаписи(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	
		
КонецПроцедуры // ПриЗаписи()

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнитьШапкуДокумента();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗаполнитьШапкуДокумента(ОбъектКопирования);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	СтруктураНеДублирующихсяПолей = Новый Структура;
	СтруктураНеДублирующихсяПолей.Вставить("ОсновноеСредство");
	
	// Проверим наличие дублей в табличной части "ОсновныеСредства".
	бит_ОбщегоНазначения.ПроверитьДублированиеЗначенийВТабличнойЧасти(ЭтотОбъект
																	 ,"ОсновныеСредства"
																	 ,СтруктураНеДублирующихсяПолей
																	 ,Отказ);
																	 
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Процедура обрабатывает изменение валюты документа.
// 
Процедура ИзменениеВалютыМодуль() Экспорт

	СтруктураКурса = бит_КурсыВалют.ПолучитьКурсВалюты(ВалютаДокумента, Дата);
	
	КурсДокумента      = СтруктураКурса.Курс;
	КратностьДокумента = СтруктураКурса.Кратность;

КонецПроцедуры // ИзменениеВалютыМодуль()

// Процедура выполняет валютные пересчеты из валюты МУ в валюту документа.
// 
// Параметры:
//  ПараметрыОС.
//  ЭтоЛиквидационнаяСтоимость - Булево (По умолчанию = Ложь).
// 
Процедура ВыполнитьВалютныеПересчетыИзВалютыМУВВалютуДокументаМодуль(ПараметрыОС, ЭтоЛиквидационнаяСтоимость = Ложь) Экспорт
	
	СтруктураШапкиДокумента = бит_ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	ВидыКурсов = Новый Структура("МУ, Документ");
	
	СтруктураКурсыВалют = бит_му_ОбщегоНазначения.ПолучитьСтруктуруКурсовВалют(ЭтотОбъект,СтруктураШапкиДокумента.Дата,ВидыКурсов);
	
	МассивСуммДляПересчета = Новый Массив;

	Если НЕ ЭтоЛиквидационнаяСтоимость Тогда
		МассивСуммДляПересчета.Добавить("БалансоваяСтоимость");
		МассивСуммДляПересчета.Добавить("НачисленнаяАмортизация");
		МассивСуммДляПересчета.Добавить("ПервоначальнаяСтоимость");
		МассивСуммДляПересчета.Добавить("СуммаОбесценения");
	Иначе
		МассивСуммДляПересчета.Добавить("ЛиквидационнаяСтоимость");
	КонецЕсли; 
	
	МассивОС = Новый Массив;
	Если НЕ ЭтоЛиквидационнаяСтоимость Тогда
		Для каждого КлючИЗначение Из ПараметрыОС Цикл
			МассивОС.Добавить(КлючИЗначение.Ключ);
		КонецЦикла;
	Иначе 
		МассивОС.Добавить(ПараметрыОС.ОсновноеСредство);
	КонецЕсли; 
	
	ТаблицаДанных = ПодготовитьТаблицуДатПринятияОС(МассивОС);
	ТаблицаПериодов = ТаблицаДанных.Скопировать(, "Период");
	Курсы = бит_КурсыВалют.ПолучитьКурсыВалютПоПериодам(ТаблицаПериодов, , СтруктураКурсыВалют);
	
	СоответствиеКурсовИОС = Новый Соответствие;
	
	Для каждого Строка Из ТаблицаДанных Цикл
		СоответствиеКурсовИОС.Вставить(Строка.ОсновноеСредство, Курсы[Строка.Период])
	КонецЦикла; 

	Если НЕ ЭтоЛиквидационнаяСтоимость Тогда
		  		
		Для каждого КлючИЗначение Из ПараметрыОС Цикл
			
			КурсыМУ 	  = СоответствиеКурсовИОС[КлючИЗначение.Ключ].МУ;
			КурсыДокумент = СоответствиеКурсовИОС[КлючИЗначение.Ключ].Документ;
			
			ВНА = КлючИЗначение.Значение;
			
			Для каждого ИмяСуммы Из МассивСуммДляПересчета Цикл
				
				
				ВНА[ИмяСуммы] = бит_КурсыВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(ВНА[ИмяСуммы]
																					  ,КурсыМУ.Валюта
																					  ,КурсыДокумент.Валюта
																					  ,КурсыМУ.Курс
																					  ,КурсыДокумент.Курс
																					  ,КурсыМУ.Кратность
																					  ,КурсыДокумент.Кратность);
			КонецЦикла; 
			
		КонецЦикла;
		
	Иначе
		
		Если НЕ СоответствиеКурсовИОС[ПараметрыОС.ОсновноеСредство] = Неопределено Тогда
			КурсыМУ 	  = СоответствиеКурсовИОС[ПараметрыОС.ОсновноеСредство].МУ;
			КурсыДокумент = СоответствиеКурсовИОС[ПараметрыОС.ОсновноеСредство].Документ;
		
					
			Для каждого ИмяСуммы Из МассивСуммДляПересчета Цикл
				
				
				ПараметрыОС[ИмяСуммы] = бит_КурсыВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(ПараметрыОС[ИмяСуммы]
																					  ,КурсыМУ.Валюта
																					  ,КурсыДокумент.Валюта
																					  ,КурсыМУ.Курс
																					  ,КурсыДокумент.Курс
																					  ,КурсыМУ.Кратность
																					  ,КурсыДокумент.Кратность);
			КонецЦикла; 
		КонецЕсли; 
		
	КонецЕсли;
		
КонецПроцедуры // ВыполнитьВалютныеПересчетыИзВалютыМУВВалютуДокументаМодуль()

// Функция получает параметры, передаваемые в обработку подбора ОС.
//
Функция ЗаполнитьПараметрыПодбора() Экспорт
	
	Если ВидОперации = Перечисления.бит_му_ВидыОперацийОбесценениеОС.ОсновныеСредства Тогда
		ВидКласса = Перечисления.бит_му_ВидыКлассовОС.ОсновныеСредства;
	Иначе
		ВидКласса = Перечисления.бит_му_ВидыКлассовОС.ИнвестиционнаяСобственность;
	КонецЕсли;
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыПодбора.Вставить("Организация"		  , Организация);                             
	ПараметрыПодбора.Вставить("Режим"			  , Перечисления.бит_му_РежимыПодбораВНА.ОбесценениеОС);
	ПараметрыПодбора.Вставить("ДатаОкончания"	  , КонецМесяца(Дата));
	ПараметрыПодбора.Вставить("МОЛ"				  , МОЛ);
	ПараметрыПодбора.Вставить("Местонахождение"	  , Подразделение);
	ПараметрыПодбора.Вставить("ВидКласса"		  , ВидКласса);
	ПараметрыПодбора.Вставить("МодельУчета"		  , Перечисления.бит_му_МоделиУчетаВНА.ПоПервоначальнойСтоимости);	

	Возврат ПараметрыПодбора;
	
КонецФункции // ЗаполнитьПараметрыПодбора()

// Функция получает параметры ОС для массива ОС или одного основного средства.
// 
// Параметры:
//  ПереченьОбъектов - Массив
//  ЭтоНовыйДокумент - Булево
// 
// Возвращаемое значение:
//  Соответствие
// 
Функция ПолучитьПараметры(ПереченьОбъектов, ЭтоНовыйДокумент) Экспорт
	 		
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Организация"  , Организация);
	СтруктураПараметров.Вставить("Дата"         , Дата);
	СтруктураПараметров.Вставить("ЭтоНовый"     , ЭтоНовыйДокумент);
	// Изменение кода. Начало. 18.11.2013{{
	// СтруктураПараметров.Вставить("МоментВремени",?(Параметры.Ключ.Пустая(),Объект.Дата,Объект.Ссылка.МоментВремени()));
	Граница = Новый Граница(КонецМесяца(Дата)   , ВидГраницы.Включая);
	СтруктураПараметров.Вставить("МоментВремени", Граница);
	// Изменение кода. Конец. 18.11.2013}}
	СтруктураПараметров.Вставить("ВидДвижения"  , ВидДвижения);
	
	СтрПараметры = бит_му_ВНА.ПолучитьПараметрыДляОбесцененияВНА(ПереченьОбъектов, СтруктураПараметров);
	
	Возврат СтрПараметры;

КонецФункции // ПолучитьПараметры()

// Процедура выполняет действия необходимые при изменении СчетаУчета.
// 
// Параметры:
// 	ТекущаяСтрока - ДанныеФормыЭлементКоллекции 
//					или ДокументТабличнаяЧастьСтрока.бит_му_ОбесценениеОС.ОсновныеСредства.
// 
Процедура ИзменениеСчетаДоходовРасходов(ТекущаяСтрока) Экспорт
	
	НастройкиСубконто = бит_БухгалтерияСервер.ПолучитьНастройкиСубконто(ТекущаяСтрока.СчетДоходовРасходов, мКоличествоСубконтоМУ);									  
	
	бит_БухгалтерияКлиентСервер.ПривестиЗначенияСубконто(ТекущаяСтрока, НастройкиСубконто, "Субконто");
	
	СинхронизироватьРеквизитыОС(ТекущаяСтрока);
	
КонецПроцедуры // ИзменениеСчетаДоходовРасходов()

// Процедура выполняет расчет суммы в табличной части.
// 
// Параметры:
//   ТекущаяСтрока - ДанныеФормыЭлементКоллекции 
//					или ДокументТабличнаяЧастьСтрока.бит_му_ОбесценениеОС.ОсновныеСредства.
// 
Процедура РассчитатьСуммуВСтрокеТЧ(ТекущаяСтрока) Экспорт

	ТекущаяСтрока.Сумма = ТекущаяСтрока.БалансоваяСтоимость - ТекущаяСтрока.ВозмещаемаяСтоимость;

	Если ВидДвижения = Перечисления.бит_му_ВидыДвиженияОбесценения.ВозвратОбесценения Тогда		
		ТекущаяСтрока.Сумма = -ТекущаяСтрока.Сумма; 		
	КонецЕсли; 

КонецПроцедуры // РассчитатьСуммуВСтрокеТЧ()

// Процедура заполняет параметры в строке табличной части.
// 
// Параметры:
//  ИДСтроки     - Число.
//  СтрокаДанных - СтрокаТаблицыЗначений.
// 
Процедура ЗаполнитьСтрокуТЧПоСтрокеДанных(ИДСтроки, СтрокаДанных) Экспорт

	ТекущаяСтрока = ОсновныеСредства[ИДСтроки];	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	Если СтрокаДанных = Неопределено Тогда	
		Возврат;  	
	КонецЕсли; 
	
	ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаДанных);
	ИзменениеСчетаДоходовРасходов(ТекущаяСтрока);
	РассчитатьСуммуВСтрокеТЧ(ТекущаяСтрока);

КонецПроцедуры // ЗаполнитьСтрокуТЧПоСтрокеДанных()

// Процедура заполняет табличную часть "ОсновныеСредства".
// 
// Параметры:
//  ВыбранноеЗначение - Структура.
//  ЭтоНовыйДокумент  - Булево.
// 
Процедура ЗаполнитьТчОсновныеСредстваПоДаннымПодбора(ВыбранноеЗначение, ЭтоНовыйДокумент = Истина) Экспорт
	
	ОписаниеТаблицы = ВыбранноеЗначение.Данные;
	ТаблицаДанных = бит_ОбщегоНазначения.РаспаковатьТаблицуИзМассива(ОписаниеТаблицы.ПереченьОбъектов, ОписаниеТаблицы.ПереченьОбъектов_Колонки);
	
	МассивОС = ТаблицаДанных.ВыгрузитьКолонку("ВНА");
	бит_РаботаСКоллекциями.УдалитьПовторяющиесяЭлементыМассива(МассивОС);
	ПараметрыОбъектов = ПолучитьПараметры(МассивОС, ЭтоНовыйДокумент);
	
	ВыполнитьВалютныеПересчетыИзВалютыМУВВалютуДокументаМодуль(ПараметрыОбъектов); 
	
	ИДСтроки = 0;
	Для Каждого СтрокаТаблицы Из ТаблицаДанных Цикл
		
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("ОсновноеСредство", СтрокаТаблицы.ВНА);
		
		МассивСтрок = ОсновныеСредства.НайтиСтроки(СтруктураОтбора);
		
		Если МассивСтрок.Количество() = 0 Тогда
			НайденнаяСтрока = Неопределено;
		Иначе
			НайденнаяСтрока = МассивСтрок[0];
		КонецЕсли;
		
		Если НайденнаяСтрока = Неопределено Тогда
			
			НоваяСтрока = ОсновныеСредства.Добавить();
			НоваяСтрока.ОсновноеСредство = СтрокаТаблицы.ВНА;
			СтрокаПараметров = ПараметрыОбъектов[НоваяСтрока.ОсновноеСредство];
			ЗаполнитьСтрокуТЧПоСтрокеДанных(ИДСтроки, СтрокаПараметров);
			
		Иначе
			
			ТекстСообщения = НСтр("ru='Основное средство ""%1%"" инв. № %2% уже подобрано в строке №%3%!'");
			ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения
																					,СтрокаТаблицы.ВНА
																					,СтрокаТаблицы.ИнвентарныйНомер
																					,НайденнаяСтрока.НомерСтроки);
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
			
		КонецЕсли;
		
		ИДСтроки = ИДСтроки + 1;
		
	КонецЦикла; // По строкам таблицы данных			

КонецПроцедуры // ЗаполнитьТчОсновныеСредстваПоДаннымПодбора()

// Процедура заполняет документ.
// 
// Параметры:
//  СтруктураЗаполнения - Структура.
//
Процедура ЗаполнитьДокумент(СтруктураЗаполнения) Экспорт

	// Обязательные для заполнения поля: Дата, Организация, ВидОперации, ВидДвижения
	Для каждого КлЗнч Из СтруктураЗаполнения Цикл
		ИмяРеквизита = КлЗнч.Ключ;
		Если ИмяРеквизита = "Дата" ИЛИ ЭтотОбъект.Метаданные().Реквизиты.Найти(ИмяРеквизита) <> Неопределено Тогда
			ЭтотОбъект[ИмяРеквизита] = КлЗнч.Значение;
		КонецЕсли; 	
	КонецЦикла;
	
	// Получим валюту международного учета.
	ВалютаДокумента = бит_му_ОбщегоНазначения.ПолучитьВалютуМеждународногоУчета(Организация);
	ИзменениеВалютыМодуль();
	
	// Заполняет табличную часть "ОсновныеСредства"
	ВыбранноеЗначение = ВыполнитьПодборОС();
	ЗаполнитьТчОсновныеСредстваПоДаннымПодбора(ВыбранноеЗначение);	

КонецПроцедуры // ЗаполнитьДокумент()

// Функция подготавливает таблицу дат принятия ОС.
// 
// Параметры:
//  МассивОС - Массив
// 
// Возвращаемое значение:
//  ТаблицаЗначения
// 
Функция ПодготовитьТаблицуДатПринятияОС(МассивОС) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("СостояниеПринято", Перечисления.бит_му_СостоянияОС.ПринятоКУчету);
	Запрос.УстановитьПараметр("МассивОС", МассивОС);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	бит_му_СостоянияОС.ОсновноеСредство,
	|	бит_му_СостоянияОС.ДатаСостояния КАК Период
	|ИЗ
	|	РегистрСведений.бит_му_СостоянияОС КАК бит_му_СостоянияОС
	|ГДЕ
	|	бит_му_СостоянияОС.ОсновноеСредство В(&МассивОС)
	|	И бит_му_СостоянияОС.Состояние = &СостояниеПринято
	|	И бит_му_СостоянияОС.Организация = &Организация";
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
		
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьШапкуДокумента(ОбъектКопирования = Неопределено)
	
	НовыйВидОперации = ВидОперации;
	
	// Заполним шапку документа значениями по умолчанию.
    бит_ОбщегоНазначения.ЗаполнитьШапкуДокумента(ЭтотОбъект, бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь"), ОбъектКопирования);

	Если НЕ ЗначениеЗаполнено(НовыйВидОперации) Тогда
		// Если этого не сделать, то при создании нового система не предложит выбрать вид операции.
		ВидОперации = НовыйВидОперации;
	КонецЕсли;
	
	Если ОбъектКопирования = Неопределено
		ИЛИ НЕ ЗначениеЗаполнено(ВидДвижения) Тогда
		ВидДвижения = Перечисления.бит_му_ВидыДвиженияОбесценения.ФормированиеРезерва;
	КонецЕсли;
	
	Дата = ТекущаяДатаСеанса();
	
	ВалютаДокумента = бит_му_ОбщегоНазначения.ПолучитьВалютуМеждународногоУчета(Организация);
	
	СтруктураКурса = бит_КурсыВалют.ПолучитьКурсВалюты(ВалютаДокумента, Дата);
	
	КурсДокумента = СтруктураКурса.Курс;
	КратностьДокумента = СтруктураКурса.Кратность;
	
КонецПроцедуры

// Функция выполняет подбор ОС через обработку подбора
//
Функция ВыполнитьПодборОС()
	
	ПараметрыПодбора  = ЗаполнитьПараметрыПодбора();
	ОбработкаПодбора = Обработки.бит_му_ПодборВНА.Создать();
	ВыбранноеЗначение = ОбработкаПодбора.ВыполнитьПодборДляЗакрытия(ПараметрыПодбора);
	
	Возврат ВыбранноеЗначение;
	
КонецФункции // ВыполнитьПодборОС()

// Процедура синхронизирует значения реквизитов типа "СправочникСсылка.ОсновныеСредства"
// строки табличной части ОсновныеСредства. 
// 
// Параметры:
//  ТекущаяСтрока - ДокументТабличнаяЧастьСтрока.бит_му_ОбесценениеОС.ОсновныеСредства.
// 
Процедура СинхронизироватьРеквизитыОС(ТекущаяСтрока) 
	
	Если ТекущаяСтрока = Неопределено Тогда 		
		Возврат; 		
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.ОсновноеСредство) Тогда
		
		Для ном = 1 По мКоличествоСубконтоМУ Цикл
			
			ИмяСубконто = "Субконто" + ном;
			
			// Адаптация для ERP. Начало. 18.03.2014{{
			Если ТипЗнч(ТекущаяСтрока[ИмяСубконто]) = Тип(бит_ОбщегоНазначения.ПолучитьИмяТипаОсновныеСредства()) Тогда
			// Адаптация для ERP. Конец. 18.03.2014}}					
				ТекущаяСтрока[ИмяСубконто] = ТекущаяСтрока.ОсновноеСредство;   				
			КонецЕсли; 
			
		КонецЦикла; // По субконто
		
	КонецЕсли; 
	
КонецПроцедуры // СинхронизироватьРеквизитыОС()

// Функция получает курсы валют, необходимые для выполнения валютных пересчетов.
// 
// Параметры:
//  СтруктураШапкиДокумента  - Структура.
//  Отказ                    - Булево.
//  Заголовок                - Строка.
// 
Функция СформироватьСтруктуруКурсовВалют(СтруктураШапкиДокумента,Отказ,Заголовок) 
	
	// Получим курсы валют, неоходимые для выполнения пересчетов
	// ВидыКурсов = Новый Структура("Упр,Регл,МУ");
	ВидыКурсов = Новый Структура("Упр,Регл,МУ,Документ");
	СтруктураКурсыВалют = бит_му_ОбщегоНазначения.ПолучитьСтруктуруКурсовВалют(ЭтотОбъект,СтруктураШапкиДокумента.Дата,ВидыКурсов);
	// СтруктураКурсыВалют.Вставить("Документ",СтруктураКурсыВалют.МУ);
	
	СтрКурсов = СтруктураКурсыВалют.МУ;
	мВалютаМеждУчета = СтрКурсов.Валюта;
	Если НЕ ЗначениеЗаполнено(мВалютаМеждУчета) Тогда
		
		ТекстСообщения = НСтр("ru='Для организации ""%1%"" не указана валюта международного учета!'");
		ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения,СтруктураШапкиДокумента.Организация);
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения,,,Отказ);
		
	КонецЕсли; 
	
	Возврат СтруктураКурсыВалют;
	
КонецФункции // СформироватьСтруктуруКурсовВалют()

Функция ПолучитьСтруктуруИсторическихКурсов(СтруктураШапкиДокумента, МассивОС, Период, СтруктураКурсыВалют)
	
	ИсторическиеКурсы = бит_му_ВНА.ПолучитьСтруктуруИсторическихКурсов(СтруктураШапкиДокумента, МассивОС, Период, СтруктураКурсыВалют);	
	
	// Получим дату принятия к учету для каждого ОС.
	ТаблицаДатПринятияОС = ПодготовитьТаблицуДатПринятияОС(МассивОС);
	
	ТаблицаПериодов = ТаблицаДатПринятияОС.Скопировать();
	ТаблицаПериодов.Свернуть("Период");
	СтруктураКурсыВалютДокумент = Новый Структура;
	СтруктураКурсыВалютДокумент.Вставить("Документ", СтруктураКурсыВалют.Документ); 
	
	// Получим курсы валюты документа для каждого ОС на дату принятия к учету.
	Курсы = бит_КурсыВалют.ПолучитьКурсыВалютПоПериодам(ТаблицаПериодов, , СтруктураКурсыВалютДокумент);

	СоответствиеКурсовИОС = Новый Соответствие;
	 
	Для каждого Строка Из ТаблицаДатПринятияОС Цикл
		СоответствиеКурсовИОС.Вставить(Строка.ОсновноеСредство, Курсы[Строка.Период])
	КонецЦикла; 
	
	Для Каждого ТекОС Из ИсторическиеКурсы Цикл
		Если НЕ СоответствиеКурсовИОС[ТекОС.Ключ] = Неопределено Тогда
			ТекОС.Значение.Документ = СоответствиеКурсовИОС[ТекОС.Ключ].Документ;
		КонецЕсли; 
	КонецЦикла;

	// Для Каждого ТекОС Из ИсторическиеКурсы Цикл
	// 	ТекОС.Значение.Документ = ТекОС.Значение.МУ;
	// КонецЦикла;
	
	Возврат ИсторическиеКурсы;
	
КонецФункции

// Процедура выполняет проверку таблицы ОС.
// 
// Параметры:
//  СтруктураТаблиц  - Структура
//  Отказ            - Булево
//  Заголовок        - Строка
// 
Процедура ПроверитьТаблицыДокумента(СтруктураШапкиДокумента,СтруктураТаблиц,Отказ,Заголовок)  
	
	//ОК Калинин М. 290413
	ОК_ОБщегоНазначения.ПроверитьЗаполненостьАналитикСчетаВТабличнойЧастиДокумента(ЭтотОбъект,"ОсновныеСредства","СчетДоходовРасходов","Субконто",Отказ,Заголовок);	
	//ОК Калинин М. 
	
	КолонкиТаблицы = СтруктураТаблиц.ОС.Колонки;
	
	Для каждого СтрокаТаблицы Из СтруктураТаблиц.ОС Цикл
		
		// Ликвидационная стоимость приходит в валюте МСФО, пересчитаем ее по валюте документа 
		// для сравнения с возмещаемой стоимостью.
		ВыполнитьВалютныеПересчетыИзВалютыМУВВалютуДокументаМодуль(СтрокаТаблицы, Истина);
		
		НачалоСообщения = НСтр("ru='В строке № %1% табличной части ""Основные средства""'");
		НачалоСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(НачалоСообщения,СтрокаТаблицы.НомерСтроки);
		
		// Проверка на принятие к учету, выбытие и финансовую аренду.
		бит_му_ВНА.ПроверитьСтрокуТаблицыОС(СтрокаТаблицы,КолонкиТаблицы,СтруктураШапкиДокумента,Отказ,Заголовок);							   
		
		// Проверка соответствия вида класса виду операции документа.
		Если мВидыКлассовВидыОпераций[СтрокаТаблицы.ВидКласса] <> СтруктураШапкиДокумента.ВидОперации Тогда
			
			ТекстСообщения = НСтр("ru=' вид класса ""%1%"" основного средства ""%2%"" не соответствует виду операции документа!'");
			ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения
																				,СтрокаТаблицы.ВидКласса
																				,СтрокаТаблицы.ОсновноеСредство);
			ТекстСообщения = НачалоСообщения + ТекстСообщения;
			
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения,,,Отказ);
			
		КонецЕсли; 
		
		// Проверка модели учета
		ПараметрыКласса = СтруктураТаблиц.ПараметрыКлассов[СтрокаТаблицы.Класс];
		флУчетПоПервоначальнойСтоимости = Ложь;
		Если ПараметрыКласса <> Неопределено Тогда
			флУчетПоПервоначальнойСтоимости = ?(ПараметрыКласса.МодельУчета = Перечисления.бит_му_МоделиУчетаВНА.ПоПервоначальнойСтоимости,Истина,Ложь);
		КонецЕсли; 
		
		Если НЕ флУчетПоПервоначальнойСтоимости Тогда
			
			ТекстСообщения = НСтр("ru=' указано основное средство ""%1%"" учитываемое НЕ по первоначальной(исторической) стоимости. Обесценение невозможно!'");
			ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения,СтрокаТаблицы.ОсновноеСредство);
			
			ТекстСообщения = НачалоСообщения + ТекстСообщения;
			
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения,,,Отказ);
			
		КонецЕсли; 
		
		//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2021-06-08 (#4146)
		//Если СтруктураШапкиДокумента.ВидОперации = Перечисления.бит_му_ВидыОперацийОбесценениеОС.ОсновныеСредства Тогда
		Если СтруктураШапкиДокумента.ВидОперации = Перечисления.бит_му_ВидыОперацийОбесценениеОС.ОсновныеСредства 
			И НЕ СтрокаТаблицы.НеНачислятьАмортизацию
			Тогда
		//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2021-06-08 (#4146)
			
			// Проверки на начисление амортизации в текущем и следующем периодах.
			Если НЕ СтрокаТаблицы.НачисленаТекущий Тогда
				
				ТекстСообщения = НСтр("ru=' указано основное средство ""%1%"", по которому не начислена амортизация в текущем периоде!'");
				ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения,СтрокаТаблицы.ОсновноеСредство);
				
				ТекстСообщения = НачалоСообщения + ТекстСообщения;
				бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения,,,Отказ);
				
			КонецЕсли;  
			
			Если СтрокаТаблицы.НачисленаСледующий Тогда
				
				ТекстСообщения = НСтр("ru=' указано основное средство ""%1%"", по которому начислена амортизация в следующих периодах!'");
				ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения,СтрокаТаблицы.ОсновноеСредство);
				
				ТекстСообщения = НачалоСообщения + ТекстСообщения;
				
				бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения,,,Отказ);
				
			КонецЕсли; 				
			
		КонецЕсли; 
		
		// При формировании резерва проверка на превышение ликвидационной стоимости.
		Если СтруктураШапкиДокумента.ВидДвижения = Перечисления.бит_му_ВидыДвиженияОбесценения.ФормированиеРезерва 
			И СтрокаТаблицы.ВозмещаемаяСтоимость < СтрокаТаблицы.ЛиквидационнаяСтоимость Тогда
			
			ТекстСообщения = НСтр("ru=' указана возмещаемая стоимость: %1% меньше ликвидационной стоимости: %2%!'");
			ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения
												// ,бит_ОбщегоНазначения.ФорматСумм(СтрокаТаблицы.ВозмещаемаяСтоимость,мВалютаМеждУчета,"0.00").
												,бит_ОбщегоНазначения.ФорматСумм(СтрокаТаблицы.ВозмещаемаяСтоимость,ВалютаДокумента,"0.00")
												// ,бит_ОбщегоНазначения.ФорматСумм(СтрокаТаблицы.ЛиквидационнаяСтоимость,мВалютаМеждУчета,"0.00"));
												,бит_ОбщегоНазначения.ФорматСумм(СтрокаТаблицы.ЛиквидационнаяСтоимость,ВалютаДокумента,"0.00"));
			
			ТекстСообщения = НачалоСообщения + ТекстСообщения;
			
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения,,,Отказ);
			
		КонецЕсли; 
		
		Если СтруктураШапкиДокумента.ВидДвижения = Перечисления.бит_му_ВидыДвиженияОбесценения.ВозвратОбесценения Тогда
			
			// При возврате проверка на наличие формирования резерва.
			Если СтрокаТаблицы.ДатаФормированияРезерва>= СтруктураШапкиДокумента.Дата Тогда
				
				ТекстСообщения = НСтр("ru=' указано основное средство ""%1%"", по которому ранее не было проведено формирование резерва. Возврат обесценения невозможен!'");
				ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения,СтрокаТаблицы.ОсновноеСредство);
				
				ТекстСообщения = НачалоСообщения + ТекстСообщения;
				
				бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения,,,Отказ);
				
			КонецЕсли; 
			
			// Проверка возмещаемой стоимости
			КонтрольнаяСумма = СтрокаТаблицы.БалансоваяСтоимостьНач-СтрокаТаблицы.СуммаАмортизации;
			Если КонтрольнаяСумма < СтрокаТаблицы.ВозмещаемаяСтоимость Тогда
				
				ТекстСообщения = НСтр("ru=' возмещаемая стоимость: %1% больше чем первоначальная стоимость за минусом амортизации по первоначальным параметрам: %2%. Возврат обесценения невозможен!'");
				ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения
													,бит_ОбщегоНазначения.ФорматСумм(СтрокаТаблицы.ВозмещаемаяСтоимость,мВалютаМеждУчета)
													,бит_ОбщегоНазначения.ФорматСумм(КонтрольнаяСумма,мВалютаМеждУчета));
				
				ТекстСообщения = НачалоСообщения + ТекстСообщения;
				
				бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения,,,Отказ);
				
			КонецЕсли; 
			
		КонецЕсли; // Возврат обесценения
		
	КонецЦикла; // По строкам таблицы	
	
КонецПроцедуры // ПроверитьТаблицыДокумента()

// Процедура выполняет движения по регистрам.
//                
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента,СтруктураТаблиц,СтруктураКурсыВалют,ИсторическиеКурсы,Отказ,Заголовок)
	
	ТаблицаОС = СтруктураТаблиц.ОС;
	
	// По регистру бит_му_СобытияОС
	НаборЗаписей = Движения.бит_му_СобытияОС;
	ТаблицаЗаписей = НаборЗаписей.Выгрузить();
	ТаблицаЗаписей.Очистить();
	
	Для каждого СтрокаТаблицы Из ТаблицаОС Цикл
		
		Запись = ТаблицаЗаписей.Добавить();
		Запись.ОсновноеСредство = СтрокаТаблицы.ОсновноеСредство;
		
	КонецЦикла; // По таблице ОС 
	
	Если СтруктураШапкиДокумента.ВидДвижения = Перечисления.бит_му_ВидыДвиженияОбесценения.ВозвратОбесценения Тогда
		
		Событие = Перечисления.бит_му_СобытияОС.ВозвратОбесценения;
		
	Иначе
		
		Событие = Перечисления.бит_му_СобытияОС.ФормированиеРезерва;
		
	КонецЕсли; 
	
	
	ТаблицаЗаписей.ЗаполнитьЗначения(СтруктураШапкиДокумента.Организация,"Организация");
	ТаблицаЗаписей.ЗаполнитьЗначения(Событие                            ,"Событие");
	ТаблицаЗаписей.ЗаполнитьЗначения(Истина                             ,"Активность");	
	ТаблицаЗаписей.ЗаполнитьЗначения(СтруктураШапкиДокумента.Дата       ,"Период");
	
	НаборЗаписей.Загрузить(ТаблицаЗаписей);
	
	// По регистру бухгалтерии бит_Дополнительный_2.
	Для каждого СтрокаТаблицы Из ТаблицаОС Цикл
		
		  // Возврат обесценения
		  // ДТ СчетСниженияСтоимости КТ СчетРасходов Сумма
		  // формирование резерва
		  // ДТ СчетРасходов КТ СчетСниженияСтоимости Сумма.
		  СоздатьЗаписьПоФормированиюРезерва(СтруктураШапкиДокумента
		                                     ,СтрокаТаблицы
											 ,ИсторическиеКурсы[СтрокаТаблицы.ОсновноеСредство]
											 // ,СтруктураКурсыВалют
											 ,СтруктураШапкиДокумента.ВидДвижения);

		
		
		
	КонецЦикла; // По таблице ОС
	
	
КонецПроцедуры // ДвиженияПоРегистрам()

// Процедура формирует проводку по формированию резерва/возврату обесценения ОС.
// 
// Параметры:
//  СтруктураШапкиДокумента  - Структура.
//  СтрокаТаблицы            - СтрокаТаблицыЗначений.
//  ВалютаМУ                 - СправочникСсылка.Валюты.
//  СтруктураКурсыВалют      - Структура.
//                
Процедура СоздатьЗаписьПоФормированиюРезерва(СтруктураШапкиДокумента,СтрокаТаблицы,СтруктураКурсыВалют,ВидДвижения)

	Если СтрокаТаблицы.Сумма = 0 Тогда
	
		Возврат;
	
	КонецЕсли; 
	
	Запись = Движения.бит_Дополнительный_2.Добавить();
	
	Если ВидДвижения = Перечисления.бит_му_ВидыДвиженияОбесценения.ВозвратОбесценения Тогда
		
		 ДтКтРасходы  = "Кт";
		 ДтКтСнижение = "Дт";
		 Содержание   = "возврат обесценения";
		
	Иначе 
		 // Формирование резерва
		 ДтКтРасходы  = "Дт";
		 ДтКтСнижение = "Кт";
		 Содержание   = "формирование резерва";

	КонецЕсли; 
	
	// Заполнение атрибутов записи	
	СтруктураПараметров = Новый Структура("Организация,Период,Валюта,СчетДт,СчетКт,Сумма,Содержание"
										   ,СтруктураШапкиДокумента.Организация
										   ,СтруктураШапкиДокумента.Дата
										   // ,мВалютаМеждУчета
										   ,СтруктураКурсыВалют.Документ.Валюта
										   ,
										   ,
										   ,СтрокаТаблицы.Сумма
										   ,Содержание);
										   
										   
	
	СтруктураПараметров["Счет"+ДтКтСнижение] = СтрокаТаблицы.СчетСниженияСтоимости;
	СтруктураПараметров["Счет"+ДтКтРасходы]  = СтрокаТаблицы.СчетДоходовРасходов;
										   
	бит_му_ОбщегоНазначения.ЗаполнитьЗаписьРегистраМУ(Запись,СтруктураПараметров);											   
	
	// Заполнение аналитики	
	Для  ном = 1 по мКоличествоСубконтоМУ Цикл
		
		бит_му_ОбщегоНазначения.УстановитьСубконто(Запись["Счет"+ДтКтРасходы]
		                                            ,Запись["Субконто"+ДтКтРасходы]
													,ном
													,СтрокаТаблицы["Субконто"+ном]);			
													
		//БИТ Тртилек 12.07.2012													
		Если ТипЗнч(СтрокаТаблицы["Субконто"+ном]) = Тип("СправочникСсылка.ОбъектыСтроительства") Тогда
						
		бит_му_ОбщегоНазначения.УстановитьСубконто(Запись["Счет"+ДтКтСнижение]
                ,Запись["Субконто"+ДтКтСнижение]
				,"Объект"
				,СтрокаТаблицы["Субконто"+ном]);

		КонецЕсли;
		///БИТ Тртилек	
		
	КонецЦикла; 
	
	бит_му_ОбщегоНазначения.УстановитьСубконто(Запись["Счет"+ДтКтСнижение]
	                                            ,Запись["Субконто"+ДтКтСнижение]
												,"ОсновныеСредства"
												,СтрокаТаблицы.ОсновноеСредство);		
	
	
	// Выполнение валютных пересчетов	
	МассивИмен = Новый Массив;
	МассивИмен.Добавить("Сумма");
	бит_КурсыВалют.ВыполнитьВалютныеПересчеты(СтруктураПараметров
													,Запись
													,МассивИмен
													,СтруктураКурсыВалют
													,СтруктураКурсыВалют.Документ);

	//1С-ИжТиСи, Кондратьев, 03.2020, обновление, некомментированный исправленный код (
	Запись.ВидДвиженияМСФО = Перечисления.БИТ_ВидыДвиженияМСФО.КорректировкаМСФО;
	//1С-ИжТиСи, Кондратьев, 03.2020, обновление, некомментированный исправленный код )
	
КонецПроцедуры // СоздатьЗаписьПоСписаниюАмортизации()

#КонецОбласти

#Область Инициализация

мКоличествоСубконтоМУ = 4;

мВидыКлассовВидыОпераций = Новый Соответствие();
мВидыКлассовВидыОпераций.Вставить(Перечисления.бит_му_ВидыКлассовОС.ОсновныеСредства
                                  ,Перечисления.бит_му_ВидыОперацийОбесценениеОС.ОсновныеСредства);
мВидыКлассовВидыОпераций.Вставить(Перечисления.бит_му_ВидыКлассовОС.ИнвестиционнаяСобственность
                                  ,Перечисления.бит_му_ВидыОперацийОбесценениеОС.ИнвестиционнаяСобственность);								  

#КонецОбласти

#КонецЕсли
